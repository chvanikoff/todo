defmodule Todo.Tasks.List do
  @moduledoc """
  List of task items; each list can have many items
  """

  @type t :: %__MODULE__{}

  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__.Item

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "lists" do
    field :archived, :boolean, default: false
    field :title, :string

    has_many :items, Item

    timestamps()
  end

  @doc false
  def create_changeset(list, attrs) do
    list
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end

  def update_changeset(list, attrs) do
    list
    |> cast(attrs, [:title, :archived])
    |> validate_required([:title, :archived])
  end
end
