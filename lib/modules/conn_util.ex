defmodule Kitch.ConnUtil do
  def put_resp_headers(conn, headers) when is_list(headers) do
    Enum.reduce(headers, conn, fn {key, value}, conn ->
      Plug.Conn.put_resp_header(conn, key, value)
    end)
  end
end
