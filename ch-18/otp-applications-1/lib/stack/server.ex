defmodule Stack.Server do
  use GenServer

  def init(stash) do
    stack = Stack.Stash.get_value stash
    {:ok, {stack, stash}}
  end

  def start_link(stack) do
    GenServer.start_link __MODULE__, stack, name: __MODULE__
  end

  def pop do
    GenServer.call __MODULE__, :pop
  end

  def push(item) do
    GenServer.cast __MODULE__, {:push, item}
  end

  def handle_call(:pop, _, {[h | t], stash}), 
    do: {:reply, h, {t, stash}}

  def handle_cast({:push, item}, {stack, stash}),
    do: {:noreply, {[ item | stack ], stash}}

  def terminate(_reason, {stack, stash}) do
    Stack.Stash.save_value stash, stack
  end
end
