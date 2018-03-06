defmodule Athena do
  @ansi_escape_sequences ~r(/\e|\033|\x1B/)
  @ansi_codes %{
    "0m" => "</span>",
    "1m" => "<span style='font-weight: bold;'>",
    "4m" => "<span style='text-decoration: underline;'>",
    "30m" => "<span style='color: black;'>",
    "31m" => "<span style='color: red;'>",
    "32m" => "<span style='color: green;'>",
    "33m" => "<span style='color: yellow;'>",
    "34m" => "<span style='color: blue;'>",
    "35m" => "<span style='color: magenta;'>",
    "36m" => "<span style='color: cyan;'>",
    "37m" => "<span style='color: white;'>",
    "40m" => "<span style='background-color: black;'>",
    "41m" => "<span style='background-color: red;'>",
    "42m" => "<span style='background-color: green;'>",
    "43m" => "<span style='background-color: yellow;'>",
    "44m" => "<span style='background-color: blue;'>",
    "45m" => "<span style='background-color: magenta;'>",
    "46m" => "<span style='background-color: cyan;'>",
    "47m" => "<span style='background-color: lightgrey;'>",
    "90m" => "<span style='color: darkgrey;'>",
    "91m" => "<span style='color: lightred;'>",
    "92m" => "<span style='color: lightgreen;'>",
    "93m" => "<span style='color: lightyellow;'>",
    "94m" => "<span style='color: lightblue;'>",
    "95m" => "<span style='color: lightpink;'>",
    "96m" => "<span style='color: lightcyan;'>",
    "97m" => "<span style='color: white;'>",
    "100m" => "<span style='background-color: darkgrey;'>",
    "101m" => "<span style='background-color: lightred;'>",
    "102m" => "<span style='background-color: lightgreen;'>",
    "103m" => "<span style='background-color: lightyellow;'>",
    "104m" => "<span style='background-color: lightblue;'>",
    "105m" => "<span style='background-color: lightpink;'>",
    "106m" => "<span style='background-color: lightcyan;'>",
    "107m" => "<span style='background-color: white;'>"
  }

  @doc """
  Returns the current list of `ansi_codes` in "lexigraphical" order
  """
  def ansi_codes, do: @ansi_codes |> Enum.sort()

  @doc ~S"""
  Parses an `ansi_string` and returns the HTML output.

  ## Examples

    iex> Athena.ansi_to_html("\e[4mfoo\e[0m")
    "<span style='text-decoration: underline;'>foo</span>"

    It returns normal text when normal text is passed in
    iex> Athena.ansi_to_html("normal text")
    "normal text"

    Background Colors
    iex> Athena.ansi_to_html("My Background is \e[42mGreen\e[0m")
    "My Background is <span style='background-color: green;'>Green</span>"

    Foreground Colors
    iex> Athena.ansi_to_html("This text is \e[91mLight red\e[0m")
    "This text is <span style='color: lightred;'>Light red</span>"

    Kitchen sink
    iex> Athena.ansi_to_html("1 scenario (\e[31m1 failed\e[0m)\n8 steps (\e[31m1 failed\e[0m, \e[36m1 skipped\e[0m, \e[32m6 passed\e[0m)\n0m26.474s")
    "1 scenario (<span style='color: red;'>1 failed</span>)\n8 steps (<span style='color: red;'>1 failed</span>, <span style='color: cyan;'>1 skipped</span>, <span style='color: green;'>6 passed</span>)\n0m26.474s"
  """
  def ansi_to_html(ansi_block) do
    ansi_block
    |> escape_html_brackets()
    |> split_on_escapes()
    |> replace()
  end

  defp split_on_escapes(ansi_block) do
    ansi_block
    |> String.split(@ansi_escape_sequences)
    |> Enum.reject(&(&1 === ""))
  end

  defp replace(ansi_list, opened_tags \\ 0) do
    [head | tail] = ansi_list

    case tail do
      [] ->
        replace_item(head, opened_tags)

      _ ->
        new_opened_tags = calculate_new_tags(head, opened_tags)
        replace_item(head, opened_tags) <> replace(tail, new_opened_tags)
    end
  end

  defp calculate_new_tags(head, opened_tags) do
    cond do
      String.starts_with?(head, "[0m") ->
        0

      String.starts_with?(head, Enum.map(Map.keys(@ansi_codes), fn key -> "[" <> key end)) ->
        opened_tags + 1

      true ->
        opened_tags
    end
  end

  defp replace_item(item, opened_tags) do
    case Regex.run(~r/\A\[(\d+)m/, item) do
      nil ->
        item

      [_, "0"] ->
        close_sequence(item, opened_tags)

      _ ->
        Regex.replace(~r/\[(\d+m)/, item, fn _, x -> fetch_ansi_code(x) end)
    end
  end

  defp fetch_ansi_code(code) do
    case Map.fetch(@ansi_codes, code) do
      :error -> raise("No translation found for #{code} in @ansi_codes.")
      {:ok, html} -> html
    end
  end

  defp close_sequence(item, opened_tags) when opened_tags === 0,
    do: String.replace(item, "[0m", "")

  defp close_sequence(item, opened_tags) do
    String.replace(item, "[0m", Enum.map_join(1..opened_tags, "", fn _ -> "</span>" end))
  end

  defp escape_html_brackets(ansi_block) do
    ansi_block
    |> String.replace("<", "&lt;")
    |> String.replace(">", "&gt;")
  end
end
