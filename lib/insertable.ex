defprotocol Insertable do
  @moduledoc """

  Insertable is a simple protocol that allows for the insertion of ellements into a collection,
  one element at a time.

  This is the major difference with the Collectable protocol:
  Collectable only works with inserting many items at a time,
  so inserting one item using Collectable requires wrapping it inside an enumerable first,
  meaning that superfluous work is done when only inserting items one by one.
  Furthermore, Collectable might perform extra work once the collecting has finished, which means that the resulting collection
  might actually be different than expected.

  One important difference, for example, is that the Insertable implementation for lists naturally inserts a new item at the _head_ side of the list.
  Collectable on the other hand builds a new list by first enumerating all items in the new collection, then putting the original items on top, and then reversing the result.
  (Thus iterating through all elements of a list every time when item(s) are inserted)

  """

  @doc """
  Insertable.insert/2 returns `{:ok, collection}` where `collection` is the new collection
  with the item having been inserted (possibly replacing an already-existing item in the process),
  or `:error` if it is impossible to insert the item (either because `item`'s format was incorrect,
  or because the `collection` is for instance full)

  ## Examples

      iex> Insertable.insert([], 1)
      {:ok, [1]}
 
      iex> Insertable.insert([1, 2, 3, 4], 5)
      {:ok, [5, 1, 2, 3, 4]}

      iex> Insertable.insert(%{a: 10, b: 20}, {:a, 30})
      {:ok, %{a: 30, b: 20}}

      iex> Insertable.insert(%{a: 1, b: 2}, 42)
      :error

      iex> {:ok, result} = Insertable.insert(MapSet.new([1, 2, 3, 4]), 33)
      iex> result
      #MapSet<[1, 2, 3, 4, 33]>
  """

  @spec insert(Insertable.t, item :: any) :: {:ok, Insertable.t} | :error
  def insert(insertable, item)
end

defimpl Insertable, for: List do
  def insert(list, item) do
    {:ok, [item | list]}
  end
end

defimpl Insertable, for: Map do
  @doc """
  Insertable.insert/2 for Map only allows inserting a `{key, value}`-tuple.
  Attempting to insert other things returns `:error`, as required by the protocol.
  """
  def insert(map, {key, value}) do
    {:ok, Map.put(map, key, value)}
  end
  def insert(_map, _) do
    :error
  end
end

defimpl Insertable, for: MapSet do
  def insert(mapset, item) do
    {:ok, MapSet.union(mapset, MapSet.new([item]))}
  end
end
