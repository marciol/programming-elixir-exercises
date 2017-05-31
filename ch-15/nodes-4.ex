defmodule TickerNode do
  @interval 2000
  @name :ticker

  def start_master do
    pid = spawn(__MODULE__, :generator, [])
    :global.register_name(@name, pid)
    TickerNode.register(pid)
    :timer.send_after(@interval, pid, { :tick, pid })
  end

  def start do
    pid = spawn(__MODULE__, :generator, [])
    TickerNode.register(pid)
  end

  def register(node_pid) do
    send :global.whereis_name(@name), { :register, node_pid }
  end

  def generator(current_node_pid \\ nil) do
    receive do
      { :register, node_pid } ->
        IO.puts "registering #{inspect node_pid}"
        add_node(current_node_pid, node_pid)
        generator(node_pid)
      { :tick, pid } ->
        IO.puts "tick from #{inspect pid}"
        tick_node(current_node_pid)
        generator(current_node_pid)
    end
  end

  defp add_node(previous_node_pid, node_pid)
    when previous_node_pid == node_pid,
    do: nil

  defp add_node(previous_node_pid, node_pid) 
    when is_nil(previous_node_pid), 
    do: send node_pid, { :register, self() }

  defp add_node(previous_node_pid, node_pid), 
    do: send node_pid, { :register, previous_node_pid }

  defp tick_node(node_pid), 
    do: :timer.send_after(@interval, node_pid, { :tick, self() })
end
