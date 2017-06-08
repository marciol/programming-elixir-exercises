defmodule Stack.Stash do
  use GenServer

  def start_link(value) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, value)
  end

  def get_value(stash) do
    GenServer.call stash, :get_value
  end

  def save_value(stash, value) do
    GenServer.cast stash, {:save_value, value}
  end

  def handle_call(:get_value, _, current_value) do
    {:reply, current_value, current_value }
  end

  def handle_cast({:save_value, value}, _current_value) do
    {:noreply, value}
  end
end
