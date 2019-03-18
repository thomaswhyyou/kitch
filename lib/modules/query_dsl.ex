defmodule Kitch.QueryDSL do
  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @target_repo Keyword.fetch!(opts, :repo)
      @can_paginate !!@target_repo.__info__(:functions)[:paginate]

      defp query(module_or_tuple, function_name, args \\ [])

      defp query({schema, queryable}, function_name, args) when is_list(args) do
        args = [queryable] ++ args
        {schema, apply(schema, function_name, args)}
      end

      defp query(schema, function_name, args) when is_list(args) do
        args = [schema] ++ args
        {schema, apply(schema, function_name, args)}
      end

      # TODO: maybe support -> preload: []
      defp return({_schema, queryable}, action, opts \\ []) when action in [:all, :one] do
        case Keyword.get(opts, :paginate) do
          nil ->
            apply(@target_repo, action, [queryable])

          params ->
            unless @can_paginate, do: raise("Repo.paginate/2 not available")
            @target_repo.paginate(queryable, params)
        end
      end
    end
  end
end
