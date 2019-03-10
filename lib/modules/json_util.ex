defmodule Kitch.JsonUtil do
  def read(filename, opts \\ []) when is_binary(filename) do
    with {:ok, body} <- File.read(filename),
         {:ok, json} <- Jason.decode(body, opts) do
      {:ok, json}
    end
  end

  def read!(filename, opts \\ []) when is_binary(filename) do
    {:ok, json} = read(filename, opts)
    json
  end
end
