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
      if char == "-" do
        "x"
      else
        prefix <> char
      end
    end)
  end)

  Enum.zip_reduce(lines,"",fn elements,accumulator ->
  string = Enum.filter(elements, fn element -> element != "x" end) |> Enum.join(" ")
  cond do
    accumulator == "" -> string
    string == "" -> accumulator
    true -> accumulator <> " " <> string
  end
   end)
end
end
