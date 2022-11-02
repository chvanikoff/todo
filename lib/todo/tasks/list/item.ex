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
    field :list_id, :id

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:content, :completed])
    |> validate_required([:content, :completed])
  end
end
