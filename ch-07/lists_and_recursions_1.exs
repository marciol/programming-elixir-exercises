defmodule MyList do
  
  def mapsum(collection, func),
    do: map(collection, func) |> reduce(0, &(&1 + &2))
  
  def map(collection, func),
    do: _map(collection, func)

  defp _map([], _), do: []
  
  defp _map([ h | t ], func),
    do: [ func.(h) | _map(t, func) ]
  
  def reduce(collection, value, func),
    do: _reduce(collection, value, func)
    
  defp _reduce([], value, _), 
    do: value
    
  defp _reduce([ h | t ], value, func),
    do: _reduce(t, func.(value, h), func)
end
