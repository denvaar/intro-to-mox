defmodule DataStore do
  @typedoc """
  Just a map with a nice list and a naughty list
  """
  @type naughty_nice_list :: %{naughty: list(String.t), nice: list(String.t)}

  @callback init() :: {:ok, naughty_nice_list}
  @callback add(:nice | :naughty, String.t) :: :ok
  @callback remove(:nice | :naughty, String.t) :: :ok
  @callback names(:nice | :naughty) :: list(String.t)
  @callback toggle(String.t) :: :ok
  @callback find_status(String.t) :: :naughty | :nice
end
