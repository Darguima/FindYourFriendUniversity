defmodule FindYourFriendUniversity.Helpers do
  @moduledoc """
  The Helpers Module, with functions to convert.
  """

  @doc """
  Reduce multiple insert_all to return just one tuple.

  ## Examples

      iex> reduce_multiple_insert_all( [ { non_neg_integer, nil | [term] }, ... ] )
      {non_neg_integer, nil | [term]}

  """
  def reduce_multiple_insert_all(inserts) do
    inserts
    |> Enum.reduce({0, []}, fn {insert_rows, ret_value}, {acc_insert_rows, acc_ret_value} ->
      {insert_rows + acc_insert_rows, (ret_value || []) ++ acc_ret_value}
    end)
  end

  @doc """
  Convert an unicode UTF-8 string name to a normalized downcase ASCII string.

  By default just downcase letters will be on the final string. If you want add some other chars, let its ASCII codes at `others_allowed_chars`.

  ## Examples

      iex> normalize_string( "Luís André Côrreia Rocha" )
      luisandrecorreiarocha

      # Space ASCII code is 32
      iex> normalize_string( "Luís André Côrreia Rocha", [32] )
      luis andre correia rocha
  """
  def normalize_string(name, others_allowed_chars \\ []) do
    name
    |> String.downcase()
    |> String.normalize(:nfd)
    |> String.to_charlist()
    |> Enum.filter(fn char -> (97 <= char && char <= 122) || (char in others_allowed_chars) end)
    |> List.to_string()
  end

  @doc """
  Convert a string to an integer. Just return the integer.

  ## Examples

      iex> str_to_int( "5" )
      5
  """
  def str_to_int(string) do
    string
    |> Integer.parse()
    |> elem(0)
  end

  @doc """
  Convert a map with string keys to a atom keys map.

  ## Examples

      iex> map_keys_to_atoms( {"a": 1, "b": 2} )
      {a: 1, b: 2}
  """
  def map_keys_to_atoms(string_key_map) do
    for {key, val} <- string_key_map, into: %{}, do: {String.to_atom(key), val}
  end

  @doc """
  Merge two civil ID strings to minimize the number of 'x' characters.

  ## Examples

      iex> merge_civil_ids("234xxx61", "xxxx8961")
      "23408961"

      iex> merge_civil_ids("234xxx61", "1234x961")
      "12348961"
  """
  def merge_civil_ids(id1, id2) when is_binary(id1) and is_binary(id2) do
    id1_chars = String.graphemes(id1)
    id2_chars = String.graphemes(id2)

    # Ensure both IDs have the same length, pad with 'x' if needed
    max_length = max(length(id1_chars), length(id2_chars))

    id1_padded = id1_chars ++ List.duplicate("x", max_length - length(id1_chars))
    id2_padded = id2_chars ++ List.duplicate("x", max_length - length(id2_chars))

    # Merge character by character, preferring non-'x' characters
    Enum.zip(id1_padded, id2_padded)
    |> Enum.map(fn
      {char, "x"} -> char
      {"x", char} -> char
      {char1, char2} when char1 == char2 -> char1
      {char1, _char2} -> char1  # If different, prefer first one
    end)
    |> Enum.join("")
  end

  def merge_civil_ids(id1, id2), do: id1 || id2
end
