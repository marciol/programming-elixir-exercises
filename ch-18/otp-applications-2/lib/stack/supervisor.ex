defmodule Stack.Supervisor do
  use Supervisor

  def start_link(stash) do
    Supervisor.start_link(__MODULE__, stash)
  end

  def init(stash) do
    children = [
      worker(Stack.Server, [stash])
    ]
    supervise(children, strategy: :one_for_one)
  end
end
