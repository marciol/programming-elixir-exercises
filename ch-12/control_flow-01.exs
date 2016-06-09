defmodule ControlFlow do
  def upto(n) do
    1..n |> Enum.map(&fizzbuzz/1) 
  end

  defp fizzbuzz(n) do
    test = { rem(n, 3), rem(n, 5), n }
    case test do
      {0, 0, _} -> "FizzBuzz" 
      {0, _, _} -> "Fizz"
      {_, 0, _} -> "Buzz"
      {_, _, n} -> n     
    end
  end 
end