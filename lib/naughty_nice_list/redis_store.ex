defmodule NaughtyNiceList.RedisStore do
  @behaviour DataStore

  @initial_state %{naughty: [], nice: []}

  def init do
    @initial_state
  end

  def add(_list, _name) do
  end

  def remove(_list, _name) do
  end

  def names(_list) do
  end

  def toggle(_name) do
  end

  def find_status(_name) do
  end
end
