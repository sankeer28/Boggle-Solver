defmodule Boggle do
  @moduledoc """
    Add your boggle function below. You may add additional helper functions if you desire. 
    Test your code by running 'mix test' from the tester_ex_simple directory.
  """

  def boggle(board, words) do
    word_set = MapSet.new( words )
    trie = build_word_prefixes( words )
    n = tuple_size( board )
    directions = get_directions()
    search_board( board , word_set , trie, n, directions)
  end


  defp search_board(board, word_set, trie, n, directions) do
    Enum.reduce( 0..( n - 1 ), %{}, fn x, acc ->
      Enum.reduce( 0..( n - 1 ), acc, fn y, acc2 ->
        merge( acc2 , find_words( board , word_set, trie , {x, y}, directions ))
      end )
    end )
  end


  defp search_all_directions(board, word_set, trie, position, directions, new_word, new_visited, new_coords) do
    Enum.reduce(directions, %{}, fn dir, acc ->
      new_position = move_to_direction(position, dir)
      found_words = find_words(board, word_set, trie, new_position, directions, new_word, new_visited, new_coords)
      merge(acc, found_words)
    end)
  end
  

  defp find_words(board, word_set, trie, position, directions, word\\ "", visited \\ %{}, coords \\ []) do
    if valid_position?(board, position, visited) do
      new_coords = [position | coords]
      new_visited = Map.put(visited, position, true)
      new_word = word <> get_letter(board, position)
      process_word(board, word_set, trie, position, directions, new_word, new_visited, new_coords)
    else
      %{}
    end
  end
   

  defp process_word(board, word_set, trie, position, directions, new_word, new_visited, new_coords) do
    if trie[new_word] do
      if new_word in word_set do
        found_words = search_all_directions(board, word_set, trie, position, directions, new_word, new_visited, new_coords)
        merge(found_words, %{new_word => Enum.reverse(new_coords)})
      else
        search_all_directions(board, word_set, trie, position, directions, new_word, new_visited, new_coords)
      end
    else
      %{}
    end
  end
  

  defp merge(map1, map2) do
    Enum.reduce(map2, map1, fn {key, value}, acc ->
      updated_map = Map.put(acc, key, value)
      updated_map
    end)
  end
  

  defp valid_position?(board, { x, y }, visited) do
    if x in 0..( tuple_size( board ) - 1) do
      if y in 0.. (tuple_size(elem( board, 0 )) - 1) do
        if !Map.has_key?( visited, {x, y }) do
          true
        else
          false
        end
      else
        false
      end
    else
      false
    end
  end

  defp get_letter(board, {x, y}) do
    row = elem(board, x)
    letter = elem(row, y)
    letter
  end
  
  
  defp build_word_prefixes(words) do
    Enum.reduce(words, %{}, fn word, trie ->
      Enum.reduce(1..byte_size(word), trie, fn i, trie ->
        prefix = String.split_at(word, i)  |> elem(0)
        Map.put(trie, prefix, true)
      end)
    end)
  end
  
  defp get_directions do
    directions = for x <- -1..1, 
                    y <- -1..1, 
                    x != 0 or y != 0, 
                    do: {x, y}
    directions
  end  


  defp move_to_direction(position, direction) do
    {x, y} = position
    {dx, dy} = direction
    {x + dx, y + dy}
  end
 
end
