defmodule Todo.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todo.Tasks` context.
  """

  @doc """
  Generate a list.
  """
  def list_fixture(attrs \\ %{}) do
    {:ok, list} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> Todo.Tasks.create_list()

    list
  end

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    list = list_fixture()

    {:ok, %{item: item}} =
      attrs
      |> Enum.into(%{
        content: "some content",
        list_id: list.id
      })
      |> Todo.Tasks.create_item()

    item
  end
end
