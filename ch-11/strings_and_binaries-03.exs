defmodule StringsAndBinaries do
  def calculate(str), do: _calculate(str)

  defp _calculate(str) do
    {l, op, r} = _parse(str)
    case op do
      '+' -> l + r
      '-' -> l - r
      '*' -> l * r
      '/' -> l / r
    end
  end 

  defp _parse(str, acc \\ {[], [], []})

  defp _parse([], {l, op, r}) do
    with {ln, _} <- Enum.reverse(l) |> List.to_string |> Integer.parse,
         {rn, _} <- Enum.reverse(r) |> List.to_string |> Integer.parse do
           case {ln, rn} do
             {ln, rn} when is_number(ln) and is_number(rn) -> {ln, op, rn}
             _ -> 
              raise "Error when parsing command"
           end
         end
  end

  defp _parse([ ?\s | t ], acc), do: _parse(t, acc)

  defp _parse([ h | t ], {l, op, r})
    when h in ~c(+ - * /), do: _parse(t, {l, [ h | op ], r})

  defp _parse([ h | t ], {l, op, r})
    when op == '', do: _parse(t, {[ h | l ], op, r})

  defp _parse([ h | t ], {l, op, r})
    when op != '', do: _parse(t, {l, op, [ h | r ]})
end