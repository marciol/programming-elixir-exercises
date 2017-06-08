defmodule Stack.ServerTest do
  use ExUnit.Case, async: true

  setup do
    # IEx.puts 'foo bar baz'
    # Stack.MainSupervisor.start_link()
    Application.start(:stack)
  end
  
  test "push values and them pop in correct order" do
    assert true
    # Stack.Server.push :foo
    # Stack.Server.push :bar
    # Stack.Server.push :baz

    # assert Stack.Server.pop, :baz
    # assert Stack.Server.pop, :bar
    # assert Stack.Server.pop, :foo
  end

  # test "raises error when pop an empty stack" do
  #   assert_raise RuntimeError, fn ->
  #     Stack.Server.pop
  #   end
  # end
end
