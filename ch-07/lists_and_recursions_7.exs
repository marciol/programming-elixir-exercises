defmodule MyNumber do
  def prime_numbers_to(n) do
    for x <- MyList.span(2, n), _prime_number?({x, 2}), do: x
  end
  
  defp _prime_number?({n, n}), do: true
  
  defp _prime_number?({n, m})
    when rem(n, m) == 0,
    do: false
  
  defp _prime_number?({n, m}), 
    do: _prime_number?({n, m+1})
    
end