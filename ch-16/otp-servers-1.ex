defmodule Stack do
  use GenServer

  def handle_call(:pop, _, [h | t]), 
    do: {:reply, h, t}
end
