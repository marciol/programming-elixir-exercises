defmodule MyList do
  def max(collection),
    do: _max(collection)  

  defp _max([ h | t ]), do: _max(t, h)

  defp _max([], acc), do: acc

  defp _max([h | t], acc)
    when h > acc, do: _max(t, h)

  defp _max([h | t], acc)
    when h <= acc, do: _max(t, acc)
end
