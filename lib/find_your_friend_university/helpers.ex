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

  ## Examples

      iex> name_to_display_name( "Luís André Côrreia Rocha" )
      luisandrecorreiarocha
  """
  def name_to_display_name(name) do
    name
    |> String.downcase()
    |> String.normalize(:nfd)
    |> String.to_charlist()
    |> Enum.filter(fn char -> 97 <= char && char <= 122 end)
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

      iex> name_to_display_name( {"a": 1, "b": 2} )
      {a: 1, b: 2}
  """
  def map_keys_to_atoms(string_key_map) do
    for {key, val} <- string_key_map, into: %{}, do: {String.to_atom(key), val}
  end
end
