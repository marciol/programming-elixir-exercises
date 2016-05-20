defmodule StringsAndBinaries do
  dep capitalize_sentences(str)
    when is_binary(str), do: _capitalize_sentences(str)
    
  
  
  defp capitalize_sentences(<< h :: utf8, t :: binary >>)
    when 
end