defmodule Todo.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string
      add :archived, :boolean, default: false, null: false

      timestamps()
    end

    create index(:lists, [:id], unique: true)
  end
end
