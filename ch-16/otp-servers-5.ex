defmodule Stack do
  use GenServer

  def init(stack) do
    Process.flag(:trap_exit, true)
    {:ok, stack}
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

  def handle_call(:pop, _, [h | t]), 
    do: {:reply, h, t}

  def handle_cast({:push, item}, stack)
    when is_number(item) and item < 10,
    do: System.halt(:abort)

  def handle_cast({:push, item}, stack),
    do: {:noreply, [ item | stack ]}

  def terminate(reason, stack) do
    IO.puts "reason: #{inspect reason}, stack: #{inspect stack}"
  end
end

