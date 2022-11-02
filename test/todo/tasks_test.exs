defmodule Todo.TasksTest do
  use Todo.DataCase

  alias Todo.Tasks

  describe "lists" do
    alias Todo.Tasks.List

    import Todo.TasksFixtures

    @invalid_attrs %{archived: nil, title: nil}

    test "list_lists/0 returns all lists" do
      list = list_fixture()
      assert Tasks.list_lists() == [list]
    end

    test "get_list!/1 returns the list with given id" do
      list = list_fixture()
      assert Tasks.get_list!(list.id) == list
    end

    test "create_list/1 with valid data creates a list" do
      valid_attrs = %{archived: true, title: "some title"}

      assert {:ok, %List{} = list} = Tasks.create_list(valid_attrs)
      assert list.archived == true
      assert list.title == "some title"
    end

    test "create_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_list(@invalid_attrs)
    end

    test "update_list/2 with valid data updates the list" do
      list = list_fixture()
      update_attrs = %{archived: false, title: "some updated title"}

      assert {:ok, %List{} = list} = Tasks.update_list(list, update_attrs)
      assert list.archived == false
      assert list.title == "some updated title"
    end

    test "update_list/2 with invalid data returns error changeset" do
      list = list_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_list(list, @invalid_attrs)
      assert list == Tasks.get_list!(list.id)
    end

    test "delete_list/1 deletes the list" do
      list = list_fixture()
      assert {:ok, %List{}} = Tasks.delete_list(list)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_list!(list.id) end
    end

    test "change_list/1 returns a list changeset" do
      list = list_fixture()
      assert %Ecto.Changeset{} = Tasks.change_list(list)
    end
  end
end
