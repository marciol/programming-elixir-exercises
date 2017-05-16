defmodule TickerNode do
  @interval 2000
  @name :ticker

  def start_master do
    pid = spawn(__MODULE__, :generator, [[]])
    :global.register_name(@name, pid)
#    :timer.send_interval(@interval, pid, { :tick })
  end

  def start do
    pid = spawn(__MODULE__, :generator, [])
    TickerNode.register(pid)
  end

  def register(node_pid) do
    send :global.whereis_name(@name), { :register, client_pid }
  end

  def generator(node) do
    receive do
      { :register, pid } ->
        IO.puts "registering #{inspect pid}"
        generator([pid | clients])
      { :tick } ->
        IO.puts "tick"
        tick_client(clients)
        Enum.reverse(clients) |> generator
    end
  end

  defp add_node(previous_node, node) when is_nil(node)
    when is_nil(previous_node) do
  end


  defp tick_client([]), do: nil
  defp tick_client([c | _]), do: send c, { :tick }
end

defmodule Client do
  def start do
    pid = spawn(__MODULE__, :receiver, [])
    Ticker.register(pid)
  end

  def receiver do
    receive do
      { :tick } -> 
        IO.puts "tock in client"
        receiver()
    end
  end
end
