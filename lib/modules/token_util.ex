defmodule Kitch.TokenUtil do
  alias Kitch.DateTimeUtil

  @doc """
  Generate a url safe base64 encoded string token based on the following
  format: `type:identifier:timestamp`.

  Examples:
  * type: :confirm_email or :renew_password
  * identifier: User id or uuid to identify the resource the token was issued to.
  * timestamp: datetime of when the token was issued.
  """
  def make_token(type, identifier) when is_atom(type) do
    timestamp = DateTime.utc_now() |> DateTime.to_unix()
    formatted = "#{type}:#{identifier}:#{timestamp}"

    encode_token(formatted)
  end

  def parse_token(token) when is_binary(token) do
    with {:ok, decoded} <- decode_token(token) do
      parse_decoded(decoded)
    else
      :error -> {:error, :invalid_token}
    end
  end

  def inspect_token(token, timeout \\ 0) when is_binary(token) and is_integer(timeout) do
    with {:ok, [_, _, timestamp] = unpacked} <- parse_token(token),
         true <- DateTimeUtil.before_expiry?(timestamp, timeout) do
      {:ok, unpacked}
    else
      false -> {:error, :token_expired}
      {:error, _} = err -> err
    end
  end

  def refresh_token(token) when is_binary(token) do
    {:ok, unpacked} = parse_token(token)
    [type, identifier, _timestamp] = unpacked

    make_token(type, identifier)
  end

  #
  # Private
  #

  defp encode_token(string) when is_binary(string) do
    Base.url_encode64(string, padding: false)
  end

  defp decode_token(token) when is_binary(token) do
    Base.url_decode64(token, padding: false)
  end

  defp parse_decoded(decoded) when is_binary(decoded) do
    case String.split(decoded, ":") do
      [type, identifier, timestamp] ->
        timestamp = timestamp |> String.to_integer() |> DateTime.from_unix!()
        parsed = [String.to_atom(type), identifier, timestamp]
        {:ok, parsed}

      _ ->
        {:error, :invalid_format}
    end
  end
end
