defmodule MyTableFormatterTest do
  use ExUnit.Case
  doctest Issues

  import Issues.MyTableFormatter, only: [
    format: 2
  ]

  test "returns fomatted table" do

    expected_table = """
    | #   | created_at           | title            |
    +-----+----------------------+------------------+
    | 3   | 2015-01-01T01:01:01Z | foo bar baz      |
    +-----+----------------------+------------------+
    | 823 | 2016-01-01T01:01:01Z | foo bar baz quux |
    +-----+----------------------+------------------+
    """

    list = [
      %{
        "id" => "3",
        "created_at" => "2015-01-01T01:01:01Z",
        "title" => "foo bar baz",
        "other_data" => "other data"
      },
      %{
        "id" => "823",
        "created_at" => "2016-01-01T01:01:01Z",
        "title" => "foo bar baz quux",
        "other_data" => "other data"
      }
    ]

    result_table = Issues.MyTableFormatter.format(list, ["id", "created_at", "title"])

    assert result_table == expected_table
  end
end