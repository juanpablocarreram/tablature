defmodule Tablature do
  def parse(tab) do
    lines = tab |> String.trim() |> String.split(["\n", "\r\n"], trim: false)
    [lastGroup, segmentLines, _counter] = Enum.reduce(lines,[[],[],0], fn line, [actualTablature,listOfLists,counter] ->
      cond do
        counter == 6 -> [[],listOfLists ++ [actualTablature],0]
        true -> [actualTablature ++ [line],listOfLists,counter + 1]
      end
    end)
    segmentedLines = (segmentLines ++ [lastGroup])
    |> Enum.map(fn segment -> segment |> Enum.map(fn line ->
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
    end) end)

    Enum.reduce(segmentedLines, "", fn segment, acc ->
    segmentResult = Enum.zip_reduce(segment,["",0],fn elements, [accumulatorString, acummulatorBlanks] ->
    string = Enum.filter(elements, fn element -> element != "x" end) |> Enum.join("/")
    newAcc =
    if string == "" do
      acummulatorBlanks + 1
    else
      0
    end
    cond do
      #Si el string actual es una linea de separacion dentro de un mismo segmento
      string == "o/o/o/o/o/o" -> [accumulatorString, acummulatorBlanks]
      #Si el acumulador tiene 3 espacios seguidos
      newAcc == 3 ->
        [accumulatorString <> " _",0]

      accumulatorString == "" ->
        [string,0]
      #Si el string actual no tiene ninguna nota
      string == "" -> [accumulatorString, newAcc]
      #Si el string actual tiene alguna nota
      true -> [accumulatorString <> " " <> string,0]

    end
    end) |> List.first()
    if acc == "" do
      segmentResult
    else
      acc <> " " <> segmentResult
    end
    end)

  end
end
