defmodule MyOrder do
  def apply_taxes(orders, tax_rates) do
    total = fn
      nil, net_amount -> net_amount
      tax, net_amount -> tax + net_amount
    end
    
    for order = [
      id: _, 
      ship_to: ship_to, 
      net_amount: net_amount
    ] <- orders,
    total_amount = total.(tax_rates[ship_to], net_amount),
    do: order ++ [total_amount: total_amount]
  end
end