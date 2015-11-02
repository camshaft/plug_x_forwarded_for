defmodule PlugXForwardedForTest do
  use ExUnit.Case, async: false
  use ExCheck
  use Plug.Test

  defp ip_v4 do
    {int(0, 255), int(0, 255), int(0, 255), int(0, 255)}
  end

  defp ip_v6 do
    {int(0, 65535), int(0, 65535), int(0, 65535), int(0, 65535),
     int(0, 65535), int(0, 65535), int(0, 65535), int(0, 65535)}
  end

  defp ip do
    ip = oneof [
      ip_v6,
      ip_v4
    ]

    bind ip, fn
      ({a, b, c, d}) ->
        "#{a}.#{b}.#{c}.#{d}"
      (nums) ->
        nums
        |> :erlang.tuple_to_list()
        |> Enum.map(&(Integer.to_string(&1, 16)))
        |> Enum.join(":")
    end
  end

  defp ips do
    list(ip)
  end

  @tag timeout: :infinity
  property :plug_x_forwarded_for do
    for_all list in ips do
      expected = case list do
        [] ->
          {127, 0, 0, 1}
        [ip | _] ->
          ip |> :erlang.binary_to_list() |> :inet_parse.address() |> elem(1)
      end

      conn = conn(:get, "/")
      |> put_req_header("x-forwarded-for", Enum.join(list, ", "))

      opts = PlugXForwardedFor.init([])
      conn = PlugXForwardedFor.call(conn, opts)

      assert expected == conn.remote_ip
    end
  end
end
