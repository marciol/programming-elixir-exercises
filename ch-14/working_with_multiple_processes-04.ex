import :timer, only: [ sleep: 1 ]

defmodule WorkingWithMultipleProcesses do
  def say_hello_and_exit do
    sleep 200
    raise "exception"
  end
end

pid = spawn_link(WorkingWithMultipleProcesses, :say_hello_and_exit, [])
IO.puts inspect pid

sleep 500

receive do
  msg ->
    IO.puts inspect msg
end
