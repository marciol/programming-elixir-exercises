defmodule Stack.MainSupervisor do
  use Supervisor

  def start_link(stack, options \\ []) do
    {:ok, sup} = result = Supervisor.start_link(__MODULE__, stack, options)
    start_workers(sup, stack)
    result
  end

  def start_workers(sup, stack) do
    {:ok, stash} = Supervisor.start_child(sup, worker(Stack.Stash, [stack]))
    {:ok, _stack} = result = Supervisor.start_child(sup, supervisor(Stack.Supervisor, [stash]))
    result
  end

  def init(_) do
    supervise [], strategy: :one_for_one
  end
end
