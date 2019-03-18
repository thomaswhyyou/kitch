defmodule Kitch.DateTimeUtil do
  # timeout in seconds, 0 means no expiry
  def before_expiry?(%DateTime{} = timestamp, timeout) when is_integer(timeout) do
    case timeout do
      0 ->
        true

      _ ->
        good_until = DateTime.to_unix(timestamp) + timeout
        utc_now_in_unix() < good_until
    end
  end

  def utc_now_in_unix() do
    DateTime.utc_now() |> DateTime.to_unix()
  end
end
