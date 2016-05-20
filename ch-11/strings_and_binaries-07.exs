require MyOrder

defmodule StringAndBinaries do
  def apply_taxes_from_file(file_path, tax_rates) do
    File.open!(file_path) |> 
    IO.stream(:line) |>
    Enum.drop(1) |> 
    Enum.map(&(_prepare_line(&1) |> _apply_taxes(tax_rates)))
  end

  defp _prepare_line(str) do
    String.strip(str) |> String.split(",")
  end

  defp _apply_taxes([id, s, net_amount], tax_rates) do
    << _ :: utf8, ship_to :: binary >> = s
    MyOrder.sale_tax([id: id, ship_to: String.to_atom(s), net_amount: String.to_float(net_amount)], tax_rates)
  end
end