defmodule NaughtyNiceList do
  @moduledoc """
  Public API for Santa's Naughty and Nice list.
  """

  @store Application.get_env(:naughty_nice_list, :data_store)

  @doc ~S"""
  Initialize a new list
  """
  defdelegate init, to: @store

  @doc ~S"""
  Add a name to :nice or :naughty list
  """
  defdelegate add(list, name), to: @store

  @doc ~S"""
  Remove a name from a :nice or :naughty list
  """
  defdelegate remove(list, name), to: @store

  @doc ~S"""
  List the names in a :nice or :naughty list
  """
  defdelegate names(list), to: @store

  @doc ~S"""
  Switch a name between lists.
  """
  defdelegate toggle(name), to: @store

  @doc ~S"""
  Return the name of the list a name belongs to.
  """
  defdelegate find_status(name), to: @store

  @doc ~S"""
  Display a pretty summary of who's naughty and nice
  """
  def print_summary do
    nice_list = names(:nice)
    naughty_list = names(:naughty)

    summary = """
    NICE\t\tNAUGHTY
    ----\t\t-------
    """

    summary =
      zip_fill(nice_list, naughty_list)
      |> Enum.map(fn {nice_name, naughty_name} -> "#{nice_name}\t\t#{naughty_name}" end)
      |> Enum.reduce(summary, &(&2 <> &1 <> "\n"))

    IO.puts(summary)
  end


  defp zip_fill([], []) do
    []
  end

  defp zip_fill([a0 | nexta], []) do
    [{a0, nil} | zip_fill(nexta, [])]
  end

  defp zip_fill([], [b0 | nextb]) do
    [{nil, b0} | zip_fill([], nextb)]
  end

  defp zip_fill([a0 | nexta], [b0 | nextb]) do
    [{a0, b0} | zip_fill(nexta, nextb)]
  end
end
