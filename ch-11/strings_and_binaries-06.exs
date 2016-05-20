defmodule StringsAndBinaries do
  def capitalize_sentences(str)
    when is_binary(str), do: _capitalize_sentences(str)
 
  defp _capitalize_sentences(str) do 
    _split_sentences(str) |> _capitalize |> Enum.reverse |> Enum.join(" ")
  end

  defp _split_sentences(str, s \\ "", ss \\ [])

  defp _split_sentences(<< h :: utf8, t :: binary >>, s, ss)
    when h == ?. do 
      s = String.reverse(<< h :: utf8, s :: binary >>) |> String.strip
      _split_sentences(t, "", [ s | ss ])
  end

  defp _split_sentences(<< h :: utf8, t :: binary >>, s, ss), 
    do: _split_sentences(t, << h :: utf8, s :: binary >>, ss)

  defp _split_sentences(<<>>, _, ss), do: ss

  defp _capitalize(ss), do: ss |> Enum.map(&String.capitalize/1)
end