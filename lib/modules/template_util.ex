defmodule Kitch.TemplateUtil do
  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      templates_root =
        opts[:root] || raise(ArgumentError, "expected :root to be given as an option")

      match_pattern = opts[:pattern] || "*"

      def render(tmpl_name, assigns \\ %{}) do
        file_name = String.trim_trailing(tmpl_name, ".eex")

        try do
          apply(__MODULE__, String.to_atom(file_name), [assigns])
        rescue
          UndefinedFunctionError -> nil
        end
      end

      # Precompile templates
      (fn ->
         require EEx

         templates = Path.wildcard(templates_root <> match_pattern)

         for t <- templates do
           name = t |> Path.basename(".eex") |> String.to_atom()
           EEx.function_from_file(:def, name, t, [:assigns])
         end
       end).()
    end
  end
end
