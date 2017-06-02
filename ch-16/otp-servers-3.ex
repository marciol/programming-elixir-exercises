defmodule Stack do
  use GenServer

  def start_link(stack) do
    GenServer.start_link __MODULE__, stack, name: __MODULE__
  end

  def pop do
    GenServer.call __MODULE__, :pop
  end

  def push(item) do
    GenServer.call __MODULE__, {:push, item}
  end

  def handle_call(:pop, _, [h | t]), 
    do: {:reply, h, t}

  def handle_cast({:push, item}, stack),
    do: {:noreply, [ item | stack ]}
end
