defmodule Kitch.PrintUtil do
  @moduledoc """
  References:

  https://github.com/blackode/printex
  https://github.com/elixir-lang/elixir/blob/v1.5.2/lib/mix/lib/mix/shell/io.ex
  https://github.com/elixir-lang/elixir/blob/v1.5.2/lib/elixir/lib/io/ansi.ex

  """

  alias IO.ANSI

  def info(message, prefix \\ "INFO ====>") do
    prefix = highlight(prefix, :cyan, :black)
    message = ANSI.format(cyan(message))
    IO.puts("#{prefix} #{message}")
  end

  def error(message, prefix \\ "ERROR ====>") do
    prefix = highlight(prefix, :red, :white)
    message = ANSI.format(red(message))
    IO.puts(:stderr, "#{prefix} #{message}")
  end


  #
  # Private
  #

  defp cyan(message) do
    [:cyan, :bright, message]
  end

  defp red(message) do
    [:red, :bright, message]
  end

  defp highlight(string, bgcolor, fgcolor) do
    color_bg(bgcolor) <> color_fg(fgcolor) <> string <> ANSI.reset
  end

  defp color_fg(color) when is_atom(color) do
    case color do
      :cyan           -> ANSI.cyan()
      :light_cyan     -> ANSI.light_cyan()
      :blue           -> ANSI.blue()
      :light_blue     -> ANSI.light_blue()
      :black          -> ANSI.black()
      :light_black    -> ANSI.light_black()
      :yellow         -> ANSI.yellow()
      :light_yellow   -> ANSI.light_yellow()
      :green          -> ANSI.green()
      :light_green    -> ANSI.light_green()
      :magenta        -> ANSI.magenta()
      :light_magenta  -> ANSI.light_magenta()
      :red            -> ANSI.red()
      :light_red      -> ANSI.light_red()
      :white          -> ANSI.white()
      :light_white    -> ANSI.light_white()
      _ -> raise "color did not matched"
    end
  end

  defp color_bg(color) when is_atom(color) do
    case color do
      :cyan           -> ANSI.cyan_background()
      :light_cyan     -> ANSI.light_cyan_background()
      :blue           -> ANSI.blue_background()
      :light_blue     -> ANSI.light_blue_background()
      :black          -> ANSI.black_background()
      :light_black    -> ANSI.light_black_background()
      :yellow         -> ANSI.yellow_background()
      :light_yellow   -> ANSI.light_yellow_background()
      :green          -> ANSI.green_background()
      :light_green    -> ANSI.light_green_background()
      :magenta        -> ANSI.magenta_background()
      :light_magenta  -> ANSI.light_magenta_background()
      :red            -> ANSI.red_background()
      :light_red      -> ANSI.light_red_background()
      :white          -> ANSI.white_background()
      :light_white    -> ANSI.light_white_background()
      _ -> raise "color did not matched"
    end
  end
end
