defmodule Kitch.MapUtil do
  def find_key_by_value(map, value) when is_map(map) do
    # Probably not very performant.. Use responsively.
    map
    |> Enum.find(fn {_, val} -> val == value end)
    |> case do
      nil -> nil
      {val, _} -> val
    end
  end

  # Shouldn't call on untrusted input b/c atoms are not garbage collected
  def atomize_keys(%{} = map) do
    do_atomize_keys(map)
  end

  def atomize_keys_r(%{} = map) do
    do_atomize_keys(map, recursively: true)
  end

  def atomize_keys_r(list) when is_list(list) do
    Enum.map(list, fn item -> atomize_keys_r(item) end)
  end

  def atomize_keys_r(value) do
    value
  end

  defp do_atomize_keys(%{} = map, opts \\ []) do
    recursively = Keyword.get(opts, :recursively, false)

    Map.new(map, fn {key, val} ->
      atom_key = String.to_atom("#{key}")

      case recursively do
        true -> {atom_key, atomize_keys_r(val)}
        false -> {atom_key, val}
      end
    end)
  end
end
