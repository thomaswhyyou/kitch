defmodule Kitch.StringUtil do
  def downcase_maybe(nil), do: nil

  def downcase_maybe(str) when is_binary(str),
    do: String.downcase(str)
end
