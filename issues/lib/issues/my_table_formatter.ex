defmodule Issues.MyTableFormatter do
  def format(list, keys, opts \\ [pad_size: 1])

  @doc """
  Takes a list of rows as Maps and a list of strings, which references keys existents on Maps passed in the first list
  Returns a formatted table where the keys are setted as header columns followed by each row.

  ## Example

      iex> list = [
      ...>    %{
      ...>     "id" => "3",
      ...>      "created_at" => "2015-01-01T01:01:01Z",
      ...>      "title" => "foo bar baz",
      ...>      "other_data" => "other data"
      ...>    },
      ...>    %{
      ...>      "id" => "823",
      ...>      "created_at" => "2016-01-01T01:01:01Z",
      ...>      "title" => "foo bar baz quux",
      ...>      "other_data" => "other data"
      ...>    }
      ...>  ]
      iex> Issues.MyTableFormatter.format(list, ["id", "created_at", "title"])
      \"""
      | #   | created_at           | title            |
      +-----+----------------------+------------------+
      | 3   | 2015-01-01T01:01:01Z | foo bar baz      |
      +-----+----------------------+------------------+
      | 823 | 2016-01-01T01:01:01Z | foo bar baz quux |
      +-----+----------------------+------------------+
      \"""
  """

  def format(list, keys, pad_size: pad_size) do
    column_sizes = _column_sizes_for(list, keys)
    column_headers = List.replace_at keys, Enum.find_index(keys, &(&1 == "id")), "#"
    header = build_header(column_headers, column_sizes, pad_size)
    rows = build_rows(list, keys, column_sizes, pad_size)
    build_table(header, rows)
  end

  def build_table(header, rows) do
    table = header ++ rows
    Enum.join(table, "\n") <> "\n"
  end

  def build_header(keys, column_sizes, pad_size) do
    [_build_row(keys, column_sizes, pad_size), _build_hr(column_sizes, pad_size)]
  end

  def build_rows(list, keys, column_sizes, pad_size) do
    Enum.flat_map list, fn r ->  
      row = 
        _extract_values(r, keys)
        |> _build_row(column_sizes, pad_size)
      [row, _build_hr(column_sizes, pad_size)]
    end
  end

  def _build_row(row, column_sizes, pad_size) do
    row_content = row |> Enum.map(&to_string/1) |> Enum.zip(column_sizes) |> Enum.map(fn {str, size} -> String.ljust(str, size) end)
    "|" <> String.duplicate(" ", pad_size) <> Enum.join(row_content, " | ") <> String.duplicate(" ", pad_size) <> "|"
  end

  def _build_hr(column_sizes, pad_size) do
    total_pad_size = pad_size * 2
    content =
      Enum.map column_sizes, 
        fn size -> 
          Stream.repeatedly(fn -> "-" end) |> Enum.take(size + total_pad_size)
        end

    line = Enum.join(content, "+")

    "+" <> line <> "+"
  end

  defp _column_sizes_for(list, keys, column_sizes \\ [])

  defp _column_sizes_for([], _, column_sizes), do: column_sizes

  defp _column_sizes_for([ h | t ], keys, column_sizes) do
    values = _extract_values(h, keys)
    column_sizes = _max_column_size(values, column_sizes)
    _column_sizes_for(t, keys, column_sizes)
  end

  defp _extract_values(row, keys) do
    for k <- keys do
      %{ ^k => value } = row 
      value
    end
  end

  defp _max_column_size(list1, list2, acc \\ [])

  defp _max_column_size([ h1 | t1 ], list2, acc)
    when not is_binary(h1), do: _max_column_size([ to_string(h1) | t1 ], list2, acc)

  defp _max_column_size([ h1 | t1 ], [ h2 | t2 ], acc)
    when byte_size(h1) > h2, do: _max_column_size(t1, t2, [ byte_size(h1) | acc ])

  defp _max_column_size([ h1 | t1 ], [ h2 | t2 ], acc)
    when byte_size(h1) <= h2, do: _max_column_size(t1, t2, [ h2 | acc ])

  defp _max_column_size([], [ h2 | t2 ], acc), do: _max_column_size([], t2, [ byte_size(h2) | acc ])

  defp _max_column_size([ h1 | t1 ], [], acc), do: _max_column_size([], t1, [ byte_size(h1) | acc ])

  defp _max_column_size([], [], acc), do: Enum.reverse(acc)
end