defmodule Stack.MixFile do
  use Mix.Project

  def project do
    [
      app: :stack, 
      version: "0.0.1"
    ]
  end

  def application do
    [
      mod: {Stack, []},
      env: [initial_stack: []]
    ]
  end
end
