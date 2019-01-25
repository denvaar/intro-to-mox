defmodule NaughtyNiceList.AgentStore do
  @behaviour DataStore

  @initial_state %{naughty: [], nice: []}

  @impl DataStore
  def init do
    case start_agent() do
      {:ok, _pid} ->
        {:ok, @initial_state}
      {:error, {:already_started, _pid}} ->
        Agent.stop(__MODULE__)
        init()
    end
  end

  @impl DataStore
  def add(:nice, name), do: add_to_list(:nice, name)
  def add(:naughty, name), do: add_to_list(:naughty, name)
  def add(_list, _name), do: nil

  @impl DataStore
  def remove(:nice, name), do: remove_from_list(:nice, name)
  def remove(:naughty, name), do: remove_from_list(:naughty, name)
  def remove(_list, _name), do: nil

  @impl DataStore
  def names(:nice), do: get_names(:nice)
  def names(:naughty), do: get_names(:naughty)
  def names(_), do: nil

  @impl DataStore
  def toggle(name) do
    with status <- find_status(name) do
      status
      |> remove(name)

      status
      |> opposite_list()
      |> add(name)
    end
  end

  @impl DataStore
  def find_status(name) do
    %{naughty: naughty_list,
      nice: nice_list} =
        Agent.get(__MODULE__, &(&1))

    cond do
      Enum.find(naughty_list, &(&1 == name)) ->
        :naughty
      Enum.find(nice_list, &(&1 == name)) ->
        :nice
    end
  end

  defp start_agent do
    Agent.start_link(
      fn -> @initial_state end,
      name: __MODULE__)
  end

  defp get_names(list_key) do
    Agent.get(
      __MODULE__,
      fn state -> state[list_key] end)
  end

  defp add_to_list(list_key, name) do
    Agent.cast(
      __MODULE__,
      fn state -> %{state | list_key => [name | state[list_key]]} end)
  end

  defp remove_from_list(list_key, name) do
    Agent.update(
      __MODULE__,
      fn state -> %{state | list_key => Enum.filter(state[list_key], &(&1 != name))} end)
  end

  defp opposite_list(:nice), do: :naughty
  defp opposite_list(:naughty), do: :nice
  defp opposite_list(_), do: nil
end
