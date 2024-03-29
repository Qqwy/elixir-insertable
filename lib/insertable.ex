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

  use TypeCheck

  @doc """
  Insertable.insert/2 returns `{:ok, collection}` where `collection` is the new collection
  with the item having been inserted (possibly replacing an already-existing item in the process),
  or `{:error, reason}` if it is impossible to insert the item for some reason.

  The following error reasons are standardized, allowing the caller to handle them gracefully:

  - `:invalid_item_type`: To be returned if the item cannot be inserted because it is incompatible with the stuff already inside the collection.
      Examples of this would be Maps, for which only `{key, value}`-items make sense,
      or for instance matrices, for which only vectors of the same size as the matrix' height make sense.
  - `:full`: To be returned if the collection only allows a limited number of items, and one first should be removed again after another item can be inserted.


  ## Examples

      iex> Insertable.insert([], 1)
      {:ok, [1]}

      iex> Insertable.insert([1, 2, 3, 4], 5)
      {:ok, [5, 1, 2, 3, 4]}

      iex> Insertable.insert(%{a: 10, b: 20}, {:a, 30})
      {:ok, %{a: 30, b: 20}}

      iex> Insertable.insert(%{a: 1, b: 2}, 42)
      {:error, :invalid_item_type}

      iex> {:ok, result} = Insertable.insert(MapSet.new([1, 2, 3, 4]), 33)
      iex> result
      #MapSet<[1, 2, 3, 4, 33]>

      iex> Insertable.insert(5..10, 4)
      {:ok, 4..10}

      iex> Insertable.insert(5..10, 3)
      {:error, :invalid_item_value}

      iex> Insertable.insert(5..10, "oops")
      {:error, :invalid_item_type}
  """

  @spec! insert(impl(Insertable), item :: any()) :: {:ok, impl(Insertable)} | {:error, :invalid_item_type} | {:error, :full} | {:error, other_reason :: any()}
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
  Attempting to insert other things returns `{:error, :invalid_item_type}`, as required by the protocol.
  """
  def insert(map, {key, value}) do
    {:ok, Map.put(map, key, value)}
  end
  def insert(_map, _) do
    {:error, :invalid_item_type}
  end
end

defimpl Insertable, for: MapSet do
  def insert(mapset, item) do
    {:ok, MapSet.union(mapset, MapSet.new([item]))}
  end
end


defimpl Insertable, for: Range do

  @doc """
  Insertion into `range` is only allowed when `item` is exactly one `step` before `range.first`.

  In Elixir versions prior to 1.12, `step` will be 1 or -1
  depending on whether `range.first` is smaller or larger than `range.last`.

  For other integer `item`s, `{:error, :invalid_item_value}` is returned.
  For non-integer `item`s, `{:error, :invalid_item_type}` is returned.
  """

  # For Elixir versions >= 1.12 (with Range `step` field)
  def insert(%{__struct__: Range, first: first, last: last, step: step}, item) when is_integer(item) do
    if item == (first - step) do
      new_range = %{__struct__: Range, first: first - step, last: last, step: step}
      {:ok, new_range}
    else
      {:error, :invalid_item_value}
    end
  end

  # For Elixir versions < 1.12 (with no Range `step` field)
  def insert(%{__struct__: Range, first: first, last: last}, item) when is_integer(item) do
    step = if first > last, do: -1, else: 1

    if item == (first - step) do
      new_range = %{__struct__: Range, first: first - step, last: last}
      {:ok, new_range}
    else
      {:error, :invalid_item_value}
    end
  end

  def insert(%{__struct__: Range}, _item) do
    {:error, :invalid_item_type}
  end
end
