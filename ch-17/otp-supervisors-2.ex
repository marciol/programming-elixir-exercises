defmodule Stack do

  defmodule Stash do
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

  defmodule StackSupervisor do
    use Supervisor

    def start_link(stash) do
      Supervisor.start_link(__MODULE__, stash)
    end

    def init(stash) do
      children = [
        worker(Stack, [stash])
      ]
      supervise(children, strategy: :one_for_one)
    end
  end

  defmodule MainSupervisor do
    use Supervisor

    def start_link(stack) do
      {:ok, sup} = result = Supervisor.start_link(__MODULE__, stack)
      start_workers(sup, stack)
      result
    end

    def start_workers(sup, stack) do
      {:ok, stash} = Supervisor.start_child(sup, worker(Stash, [stack]))
      {:ok, stack} = result = Supervisor.start_child(sup, supervisor(StackSupervisor, [stash]))
      result
    end

    def init(_) do
      supervise [], strategy: :one_for_one
    end
  end

  use GenServer

  def start(stack \\ []) do
    MainSupervisor.start_link(stack)
  end

  def init(stash) do
    # Process.flag(:trap_exit, true)
    stack = Stash.get_value stash
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

  def terminate(reason, {stack, stash}) do
    Stash.save_value stash, stack
  end
end
