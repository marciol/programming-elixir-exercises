defmodule ControlFlow do
  def ok!(result) do
    case result do
      {:ok, data} -> data 
      {:error, message} -> raise message
    end
  end
end