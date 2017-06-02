defmodule Stack do
  use GenServer

  def handle_call(:pop, _, [h | t]), 
    do: {:reply, h, t}

  def handle_cast({:push, item}, stack),
    do: {:noreply, [ item | stack ]}
end
