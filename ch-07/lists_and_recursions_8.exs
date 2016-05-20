defmodule MyOrder do
  def apply_taxes(orders, tax_rates) do
    for order <- orders,
    do: _sale_tax(order, tax_rates)
  end

  def sale_tax(order, tax_rates), do: _sale_tax(order, tax_rates)

  defp _sale_tax(order = [ id: _, ship_to: ship_to, net_amount: net_amount ], tax_rates) do
    calc_total = fn
      nil, net_amount -> net_amount
      tax, net_amount -> tax + net_amount
    end
    total_amount = calc_total.(tax_rates[ship_to], net_amount)
    order ++ [total_amount: total_amount]
  end
end