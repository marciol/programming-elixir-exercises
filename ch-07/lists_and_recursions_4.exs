defmodule MyList do
  def span(from, to), do: _span(from, to)

  defp _span(l, h)
    when l <= h, 
    do: [ l | _span(l + 1, h) ]

  defp _span(l, h)
    when l > h, do: []
end