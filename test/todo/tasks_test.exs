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
      list = list_fixture() |> Repo.preload(:items)
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
      list = list_fixture() |> Repo.preload(:items)
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

  describe "items" do
    alias Todo.Tasks.List.Item

    import Todo.TasksFixtures

    @invalid_attrs %{completed: nil, content: nil}

    test "list_items/1 returns all items in the list" do
      list1 = list_fixture()
      list2 = list_fixture()
      item1 = item_fixture(%{list_id: list1.id})
      item2 = item_fixture(%{list_id: list1.id})
      item3 = item_fixture(%{list_id: list2.id})

      result = Tasks.list_items(list1.id)

      assert item1 in result
      assert item2 in result
      refute item3 in result
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Tasks.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      list = list_fixture()
      valid_attrs = %{completed: true, content: "some content", list_id: list.id}

      assert {:ok, %Item{} = item} = Tasks.create_item(valid_attrs)
      assert item.completed == true
      assert item.content == "some content"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      update_attrs = %{completed: false, content: "some updated content"}

      assert {:ok, %Item{} = item} = Tasks.update_item(item, update_attrs)
      assert item.completed == false
      assert item.content == "some updated content"
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_item(item, @invalid_attrs)
      assert item == Tasks.get_item!(item.id)
    end

    test "switch_item_completed/1 switches the item `completed` flag" do
      item = item_fixture(%{completed: false})

      assert {:ok, %Item{} = item} = Tasks.switch_item_completed(item)
      assert item.completed == true

      assert {:ok, %Item{} = item} = Tasks.switch_item_completed(item)
      assert item.completed == false
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Tasks.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Tasks.change_item(item)
    end
  end
end
