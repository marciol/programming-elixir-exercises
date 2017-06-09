defmodule Stack.ServerTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, pid} = Stack.MainSupervisor.start_link()
    [pid: pid]
  end
  
  test "push values and them pop in correct order" do
    Stack.Server.push :foo
    Stack.Server.push :bar
    Stack.Server.push :baz

    assert Stack.Server.pop == :baz
    assert Stack.Server.pop == :bar
    assert Stack.Server.pop == :foo
  end


  @tag :capture_log
  test "restart the process without crash" do
    catch_exit do
      Stack.Server.pop
    end
    
    :timer.sleep 1
    Stack.Server.push :foo
    
    assert Stack.Server.pop == :foo
  end
end
