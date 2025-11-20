defmodule VibeBase do
  def run([filename]) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Enum.with_index()
    |> Enum.reduce(%{}, &process_line/2)
    |> subtract()
    |> IO.puts()
  end

  def run(_) do
    IO.puts("Usage: elixir vibe-base.exs <filename>")
  end

  defp process_line({line, _}, acc) when line == "" do
    acc
  end

  defp process_line({line, line_num}, acc) do
    parts =
      line
      |> String.split("|")
      |> Enum.map(&String.trim/1)

    case length(parts) do
      3 ->
        [table_name, column_list, start_row] = parts

        columns =
          column_list
          |> String.split(",")
          |> Enum.map(&String.trim/1)

        new_acc =
          acc
          |> Map.update(:number_of_tables, 1, &(&1 + 1))

        case table_name do
          "sales" ->
            new_acc
            |> Map.put(:sales, %{
              column_index: Enum.find_index(columns, &(&1 == "sale_value")),
              row_index: String.to_integer(start_row)
            })

          "expenses" ->
            new_acc
            |> Map.put(:expenses, %{
              column_index: Enum.find_index(columns, &(&1 == "expense_value")),
              row_index: String.to_integer(start_row)
            })

          _ ->
            new_acc
        end

      _ ->
        expenses = acc[:expenses]
        sales = acc[:sales]
        number_of_tables = acc[:number_of_tables]

        cond do
          sales && number_of_tables &&
              rem(line_num - number_of_tables, number_of_tables) == sales.row_index ->
            case Enum.at(String.split(line, ";"), sales.column_index) do
              value_str ->
                value = String.to_integer(value_str)
                Map.update(acc, "sale_value", value, &(&1 + value))
            end

          expenses && number_of_tables &&
              rem(line_num - number_of_tables, number_of_tables) == expenses.row_index ->
            case Enum.at(String.split(line, ";"), expenses.column_index) do
              value_str ->
                value = String.to_integer(value_str)
                Map.update(acc, "expense_value", value, &(&1 + value))
            end

          true ->
            acc
        end
    end
  end

  defp subtract(acc) do
    sales = Map.get(acc, "sale_value", 0)
    expenses = Map.get(acc, "expense_value", 0)
    sales - expenses
  end
end

VibeBase.run(System.argv())
