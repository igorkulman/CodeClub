defmodule RomanNumerals do
  def run([filename]) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&roman_to_int/1)
    |> Enum.sum()
    |> IO.puts()
  end

  def run(_) do
    IO.puts("Usage: elixir roman_numerals.exs <filename>")
  end

  defp roman_to_int(roman) do
    String.graphemes(roman)
    |> Enum.reverse()
    |> convert(0, 0, {nil, 0})
  end

  defp numeral_map do
    %{
      "I" => 1,
      "V" => 5,
      "X" => 10,
      "L" => 50,
      "C" => 100,
      "D" => 500,
      "M" => 1000
    }
  end

  defp convert([], _prevTotal, total, _) when total < 4000 do
    total
  end

  defp convert([], _prevTotal, _total, _) do
    0
  end

  defp convert([char | rest], prevTotal, total, {prev_char, count}) do
    case numeral_map()[char] do
      nil -> 0
      value ->
        new_count =
        cond do
          prev_char == nil -> 1
          prev_char == char -> count + 1
          true -> 1
        end

        if new_count > 3 do
          0
        else
          new_total = if value < prevTotal, do: total - value, else: total + value
          convert(rest, value, new_total, {char, new_count})
        end
    end
  end
end

RomanNumerals.run(System.argv())
