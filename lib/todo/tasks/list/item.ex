defmodule Todo.Tasks.List.Item do
  @moduledoc """
  Task item; each item belongs to a list.
  """

  @type t :: %__MODULE__{}

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "items" do
    field :completed, :boolean, default: false
    field :content, :string
    field :list_id, :binary_id

    timestamps()
  end

  @doc """
  Changeset used to create an item. It requires
  `:list_id` to be passed and doesn't allow the `:completed` flag
  """
  @spec create_changeset(__MODULE__.t(), map()) :: Ecto.Changeset.t()
  def create_changeset(item, attrs) do
    item
    |> cast(attrs, [:content, :list_id])
    |> validate_required([:content, :list_id])
  end

  @doc """
  Changeset used to update an item. It doesn't allow the `:list_id` flag: list
  can not be changed once item is created
  """
  @spec update_changeset(__MODULE__.t(), map()) :: Ecto.Changeset.t()
  def update_changeset(item, attrs) do
    item
    |> cast(attrs, [:content, :completed])
    |> validate_required([:content, :completed])
  end
end
