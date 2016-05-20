defmodule StringsAndBinaries do
  def center(list), do: _center(list)

  defp _center(list) do

    max = Enum.reduce list, 0, fn 
      str, acc -> _max(String.length(str), acc) 
    end 

    Enum.each list, fn
      str -> 
        cl = String.length(str)
        tv = max - cl
        v = div(tv, 2) 
        s = String.rjust(str, cl + v) |> String.ljust(max)
        IO.puts s
    end
  end

  defp _max(a, b) when a > b, do: a

  defp _max(_, b), do: b
end