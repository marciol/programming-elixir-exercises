defmodule MyList do
  def caesar(str, n),
    do: _caesar(str, n)

  defp _caesar([], _), do: []

  defp _caesar([ h | t], n)
    when (h + n) > ?z, do: [ ?? | _caesar(t, n) ]

  defp _caesar([ h | t], n),
    do: [ h + n | _caesar(t, n) ]
end