defmodule Kitch.ChangesetUtil do
  alias Ecto.Changeset

  # Copied from DataCase.errors_on/1
  def errors_on(%Changeset{} = changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Enum.reduce(opts, message, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
