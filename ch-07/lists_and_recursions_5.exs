defmodule MyList do

  def all?(coll, func), do: _all?(coll, func)
  
  defp _all?([h | t], func), do: _all?(t, func.(h), func)
  
  defp _all?([], _), do: true
  
  defp _all?(_, v, _) when not v, do: false
  
  defp _all?(coll, v, func) when v, do: _all?(coll, func)


  def each(coll, func), do: _each(coll, func)
  
  defp _each([], _), do: nil
  
  defp _each([h | t], func) do
    func.(h)
    _each(t, func)
  end

  
  def filter(coll, func), do: _filter(coll, func)
  
  defp _filter([], _), do: []
  
  defp _filter([h | t], func) do
    if func.(h) do
      [ h | _filter(t, func) ]
    else
      _filter(t, func)
    end
  end

  
  def split(coll, n), do: _split(coll, n)
  
  defp _split(coll, n, acc \\ {[], 0})
  
  defp _split([], _, {c, _}), do: [_reverse(c), []]
  
  defp _split(coll, n, {c, i})
    when n == i,
    do: [_reverse(c), coll]
    
  defp _split([h | t], n, {c, i}),
    do: _split(t, n, {[ h | c], i + 1})
    
    
  defp _reverse(coll, acc \\ [])
    
  defp _reverse([], acc), do: acc
  
  defp _reverse([h | t], acc), do: _reverse(t, [ h | acc ])
  
  def take(coll, n) do
   [a, _] = _split(coll, n)
   a
  end
end