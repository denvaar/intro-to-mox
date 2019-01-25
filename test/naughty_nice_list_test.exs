defmodule NaughtyNiceListTest do
  use ExUnit.Case

  import ExUnit.CaptureIO
  import Mox

  setup :verify_on_exit!

  test "initialize a new list" do
    NaughtyNiceList.MockStore
    |> expect(:init, fn -> {:ok, %{naughty: [], nice: []}} end)

    assert NaughtyNiceList.init() == {:ok, %{naughty: [], nice: []}}
  end

  test "pretty prints the list when there are no names" do
    NaughtyNiceList.MockStore
    |> expect(:names, fn(:nice) -> [] end)
    |> expect(:names, fn(:naughty) -> [] end)

    assert capture_io(fn -> NaughtyNiceList.print_summary end
    ) == """
    NICE\t\tNAUGHTY
    ----\t\t-------

    """
  end

  test "pretty prints the list when there are some names" do
    NaughtyNiceList.MockStore
    |> expect(:names, fn(:nice) -> ["Denver", "Niccole"] end)
    |> expect(:names, fn(:naughty) -> ["Michael"] end)

    assert capture_io(fn -> NaughtyNiceList.print_summary end
    ) == """
    NICE\t\tNAUGHTY
    ----\t\t-------
    Denver\t\tMichael
    Niccole\t\t

    """
  end
end
