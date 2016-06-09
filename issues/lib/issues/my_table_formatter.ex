defmodule Issues.MyTableFormatter do
  def format(list, keys) do
    column_sizes = _column_sizes_for(list, keys)
    header = build_header(keys, column_sizes)
    rows = build_rows(list, keys, column_sizes)
    build_table(header, rows)
  end

  def build_table(header, rows) do
    table = header ++ rows
    Enum.join(table, "\n") <> "\n"
  end

  def build_header(keys, column_sizes) do
    [_build_row(keys, column_sizes), _build_line(column_sizes)]
  end

  def build_rows(list, column_sizes) do
    Enum.flat_map list, fn row ->  
      row_content = 
        _extract_values(row)
        |> _build_row(column_sizes)
      [row_content, _build_line(column_sizes)]
    end
  end

  def _build_row(row, column_sizes) do
    row_content = keys |> Enum.zip(column_sizes) |> Enum.map(fn {str, size} -> String.ljust(str, size) end)
    "| " <> Enum.join(row_content, " | ") <> " |"
  end

  def _build_line(column_sizes) do
    line_content =
      Enum.map column_size, 
        fn size -> 
          Stream.repeatedly(fn -> "-" end) |> Enum.take(size)
        end
      |> Enum.join(" + ")

    "+ " <> line_content <> " +"
  end

  defp _column_sizes_for(list, keys, column_sizes \\ [])

  defp _column_sizes_for([ h | t ], keys) do
    values = _extract_values(h, keys)
    column_sizes = _max_column_size(values, column_sizes)
    _column_sizes_for(t, keys, column_sizes)
  end

  defp _extract_values(row, keys) do
    for k <- keys do
      %{ ^k => value } = h 
      value
    end
  end

  defp _max_column_size([ h1 | t1 ], [ h2 | t2 ], acc)
    when byte_size(h1) > byte_size(h2), do: _max_column_size(t1, t2, [ byte_size(h1) | acc ])

  defp _max_column_size([ h1 | t1 ], [ h2 | t2 ], acc)
    when byte_size(h1) <= byte_size(h2), do: _max_column_size(t1, t2, [ byte_size(h2) | acc ])

  defp _max_column_size([], [ h2 | t2 ], acc), do: _max_column_size([], t2, [ byte_size(h2) | acc ])

  defp _max_column_size([ h1 | t1 ], [], acc), do: _max_column_size([], t1, [ byte_size(h1) | acc ])

  defp _max_column_size([], [], acc), do: List.reverse(acc)
end