defmodule Tablature do
  def parse(tab) do
  lines = String.split(tab,["\n", "\r\n"], trim: true)
  |> Enum.map(fn line ->
    prefix = (Regex.run(~r/\D/, line) |> List.first())
    # 2. Iterate through the graphemes of the line cleanly
    line
    |> String.slice(2..-2 // 1)
    |> String.graphemes()
    |> Enum.map(fn char ->
      cond do
        char == "-" -> "x"
        char == "|" -> "o"
        true -> prefix <> char
      end
    end)
  end)

  Enum.zip_reduce(lines,["",0],fn elements, [accumulatorString, acummulatorBlanks] ->
  string = Enum.filter(elements, fn element -> element != "x" end) |> Enum.join("/")
  cond do
    string == "o/o/o/o/o/o" -> [accumulatorString, acummulatorBlanks]
    acummulatorBlanks == 3 -> [accumulatorString <> " " <> "_ " <> string,0]
    accumulatorString == "" ->
    if string == "" do
      [accumulatorString, acummulatorBlanks + 1]
    else
      [string, acummulatorBlanks]
    end
    string == "" -> [accumulatorString, acummulatorBlanks + 1]
    true -> [accumulatorString <> " " <> string,0]
  end
   end) |> List.first()
end
end
