# Insertable

A lightweight reusable Insertable protocol, allowing insertion elements one-at-a-time into a collection.

## Description

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


## Examples

```elixir
iex> Insertable.insert([], 1)
{:ok, [1]}

iex> Insertable.insert([1, 2, 3, 4], 5)
{:ok, [5, 1, 2, 3, 4]}

iex> Insertable.insert(%{a: 10, b: 20}, {a: 30})
{:ok, %{a: 10, b: 20}}

iex> Insertable.insert(%{a: 1, b: 2}, 42)
:error

iex> Insertable.insert(MapSet.new([1, 2, 3, 4], 33))
#MapSet<[1, 2, 3, 4, 33]>
```

## Installation

The package can be installed
by adding `insertable` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:insertable, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/insertable](https://hexdocs.pm/insertable).

