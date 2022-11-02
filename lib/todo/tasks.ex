defmodule Todo.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false

  alias Todo.Repo
  alias __MODULE__.List
  alias __MODULE__.List.Item

  @doc """
  Returns the list of lists.

  ## Examples

      iex> list_lists()
      [%List{}, ...]

  """
  @spec list_lists() :: [List.t()]
  def list_lists do
    Repo.all(List)
  end

  @doc """
  Gets a single list with items preloaded.

  Raises `Ecto.NoResultsError` if the List does not exist.

  ## Examples

      iex> get_list!(123)
      %List{items: [%Item{}]}

      iex> get_list!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_list!(Ecto.UUID.t()) :: List.t() | no_return()
  def get_list!(id) do
    List
    |> Repo.get!(id)
    |> Repo.preload(:items)
  end

  @doc """
  Creates a list.

  ## Examples

      iex> create_list(%{field: value})
      {:ok, %List{}}

      iex> create_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_list(map()) :: {:ok, List.t()} | {:error, Ecto.Changeset.t()}
  def create_list(attrs \\ %{}) do
    %List{}
    |> List.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a list.

  ## Examples

      iex> update_list(list, %{field: new_value})
      {:ok, %List{}}

      iex> update_list(list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_list(List.t(), map()) :: {:ok, List.t()} | {:error, Ecto.Changeset.t()}
  def update_list(%List{} = list, attrs) do
    list
    |> List.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Switches the list `archived` flag to opposite

  ## Examples

      iex> switch_list_archived(%List{archived: false})
      {:ok, %List{archived: true}}

      iex> switch_list_archived(%List{archived: true})
      {:ok, %List{archived: false}}
  """
  @spec switch_list_archived(List.t()) :: {:ok, List.t()} | {:error, Ecto.Changeset.t()}
  def switch_list_archived(%List{} = list) do
    update_list(list, %{archived: not list.archived})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking list changes.

  ## Examples

      iex> change_list(list)
      %Ecto.Changeset{data: %List{}}

  """
  @spec change_list(List.t() | :new, map()) :: Ecto.Changeset.t()
  def change_list(list, attrs \\ %{})

  def change_list(:new, attrs) do
    List.create_changeset(%List{}, attrs)
  end

  def change_list(%List{} = list, attrs) do
    List.update_changeset(list, attrs)
  end

  @doc """
  Returns the list of items in the list.

  ## Examples

      iex> list_items(42)
      [%Item{list_id: 42}, ...]

  """
  @spec list_items(Ecto.UUID.t()) :: [Item.t()]
  def list_items(list_id) do
    query =
      from i in Item,
        where: i.list_id == ^list_id

    Repo.all(query)
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
  @spec get_item!(Ecto.UUID.t()) :: Item.t() | no_return()
  def get_item!(id), do: Repo.get!(Item, id)

  @doc """
  Creates a item.

  ## Examples

      iex> create_item(%{field: value})
      {:ok, %Item{}}

      iex> create_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_item(map()) :: {:ok, Item.t()} | {:error, Ecto.Changeset.t()}
  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a item.

  ## Examples

      iex> update_item(item, %{field: new_value})
      {:ok, %Item{}}

      iex> update_item(item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_item(Item.t(), map()) :: {:ok, Item.t()} | {:error, Ecto.Changeset.t()}
  def update_item(%Item{} = item, attrs) do
    item
    |> Item.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Switches the item `completed` flag to opposite

  ## Examples

      iex> switch_item_completed(%Item{completed: false})
      {:ok, %Item{completed: true}}

      iex> switch_item_completed(%Item{completed: true})
      {:ok, %Item{completed: false}}
  """
  @spec switch_item_completed(Item.t()) :: {:ok, Item.t()} | {:error, Ecto.Changeset.t()}
  def switch_item_completed(%Item{} = item) do
    update_item(item, %{completed: not item.completed})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item changes.

  ## Examples

      iex> change_item(item)
      %Ecto.Changeset{data: %Item{}}

  """
  @spec change_item(Item.t(), map()) :: Ecto.Changeset.t()
  def change_item(item, attrs \\ %{})

  def change_item(:new, attrs) do
    Item.create_changeset(%Item{}, attrs)
  end

  def change_item(%Item{} = item, attrs) do
    Item.update_changeset(item, attrs)
  end
end
