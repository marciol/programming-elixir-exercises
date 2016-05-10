defmodule StringsAndBinaries do
  def printable?(str), do: Enum.all? str, &(&1 in ?\s..?~)
end