defmodule Kitch.ListUtil do
  # Reference: https://elixirforum.com/t/formatting-a-list-of-strings-am-i-missing-anything/18593/18?u=thomaswhyyou
  def humanize(list),
    do: humanize(list, :and)

  def humanize([], _conjunction),
    do: ""

  def humanize([a], _conjunction),
    do: to_string(a)

  def humanize([a, b], conjunction),
    do: "#{a} #{conjunction} #{b}"

  def humanize(list, conjunction),
    do: humanize(list, [], conjunction)

  defp humanize([last], strl, conjunction),
    do: to_string([strl, "#{conjunction} ", to_string(last)])

  defp humanize([h | t], strl, conjunction),
    do: humanize(t, [strl, to_string(h), ", "], conjunction)
end
