defmodule PlugXForwardedFor do
  def init(opts) do
    %{header: opts[:header] || "x-forwarded-for"}
  end

  def call(conn, %{header: header}) do
    conn
    |> Plug.Conn.get_req_header(header)
    |> parse_header(conn)
  end

  defp parse_header([], conn) do
    conn
  end
  defp parse_header([value | _], conn) do
    parse_address(value, conn)
  end

  defp parse_address(<<>>, conn) do
    conn
  end
  defp parse_address(<<" ", rest :: binary>>, conn) do
    parse_address(rest, conn)
  end
  for length <- 7..39 do
    defp parse_address(<<ip :: binary-size(unquote(length)), " ", _ :: binary>>, conn) do
      ip
      |> :erlang.binary_to_list()
      |> :inet_parse.address()
      |> replace_address(conn)
    end
    defp parse_address(<<ip :: binary-size(unquote(length)), ",", _ :: binary>>, conn) do
      ip
      |> :erlang.binary_to_list()
      |> :inet_parse.address()
      |> replace_address(conn)
    end
    defp parse_address(<<ip :: binary-size(unquote(length))>>, conn) do
      ip
      |> :erlang.binary_to_list()
      |> :inet_parse.address()
      |> replace_address(conn)
    end
  end
  defp parse_address(_, conn) do
    conn
  end

  defp replace_address({:ok, address}, conn) do
    %{conn | remote_ip: address}
  end
  defp replace_address(_, conn) do
    conn
  end
end
