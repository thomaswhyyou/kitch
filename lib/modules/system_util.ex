defmodule Kitch.SystemUtil do
  require Logger

  def halt_with_error(message) when is_binary(message) do
    Logger.error(message)
    # Otherwise quits even before error message?
    :timer.sleep(100)
    System.halt(1)
  end

  def sys_cmd(cmd, args) do
    System.cmd(cmd, args, into: IO.stream(:stdio, :line))
  end

  def sys_cmd!(cmd, args) do
    {_, 0} = sys_cmd(cmd, args)
  end
end
