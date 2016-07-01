defmodule WorkingWithMultipleProcesses do
  def say_hello_and_exit do
    exit(:boom)
  end
end

spawn_link(WorkingWithMultipleProcesses, :say_hello_and_exit, [])

import :timer, only: [ sleep: 1 ]

sleep 500

receive do
  msg ->
    IO.puts inspect msg
end

