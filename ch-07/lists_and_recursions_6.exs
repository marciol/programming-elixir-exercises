defmodule MyList do
  def flatten(coll), do: _flatten(coll)
  
  defp _flatten([[] | t]), do: _flatten(t)
  
  defp _flatten([h | t]) 
    when is_list(h),
    do: [ _flatten(h) | _flatten(t) ]
    
  defp _flatten([h | t]), do: [ h | _flatten(t) ]
  
end