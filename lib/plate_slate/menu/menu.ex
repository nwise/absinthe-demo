defmodule PlateSlate.Menu do
  @moduledoc """
  The Menu context.
  """

  import Ecto.Query, warn: false
  alias PlateSlate.Repo

  alias PlateSlate.Menu.Item
  alias PlateSlate.Menu.Category

  def list_items(args \\ :empty) do
    args
    |> Enum.reduce(Item, fn
      {:order, order}, query ->
          from q in query, order_by: {^order, :name}
      {:filter, filter}, query ->
          query |> filter_with(filter)
    end)
    |> Repo.all
  end

  def list_categories(args \\ :empty) do
    args
    |> Enum.reduce(Category, fn
      {:order, order}, query ->
          from q in query, order_by: {^order, :name}
      {:filter, filter}, query ->
          query |> filter_with(filter)
    end)
    |> Repo.all
  end

  defp filter_with(query, filter) do
    Enum.reduce(filter, query, fn
      {:name, name}, query ->
        from q in query, where: ilike(q.name, ^"%#{name}%")
      {:priced_above, price}, query ->
        from q in query, where: q.price >= ^price
      {:priced_below, price}, query ->
        from q in query, where: q.price <= ^price
      {:added_after, date}, query ->
        from q in query, where: q.added_on >= ^date
      {:added_before, date}, query ->
        from q in query, where: q.added_on <= ^date
      {:category, category_name}, query ->
        from q in query,
          join: c in assoc(q, :category),
          where: ilike(c.name, ^"%#{category_name}%")
      {:tag, tag_name}, query ->
        from q in query,
          join: t in assoc(q, :tags),
          where: ilike(t.name, ^"%#{tag_name}%")
      end)
  end

  @doc """
  Gets a single item.

  Raises `Ecto.NoResultsError` if the Item does not exist.

  ## Examples

      iex> get_item!(123)
      %Item{}

      iex> get_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item!(id), do: Repo.get!(Item, id)

end
