defmodule Todo.TasksTest do
  use Todo.DataCase

  alias Todo.Tasks

  describe "lists" do
    alias Todo.Tasks.List

    import Todo.TasksFixtures

    @invalid_attrs %{archived: nil, title: nil}

    test "list_lists/0 returns all lists ordered by inserted_at" do
      list1 = list_fixture()
      list2 = list_fixture()
      list3 = list_fixture()

      {:ok, updated_list2} = update_time_field(list2, :inserted_at, {-1, :minute})

      assert Tasks.list_lists() == [list1, list3, updated_list2]
    end

    test "get_list!/1 returns the list with given id" do
      list = list_fixture() |> Repo.preload(:items)
      assert Tasks.get_list!(list.id) == list
    end

    test "create_list/1 with valid data creates a list" do
      valid_attrs = %{archived: true, title: "some title"}

      assert {:ok, %List{} = list} = Tasks.create_list(valid_attrs)
      assert list.archived == false
      assert list.title == "some title"
    end

    test "create_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_list(@invalid_attrs)
    end

    test "update_list/2 with valid data updates the list" do
      list = list_fixture()
      update_attrs = %{archived: false, title: "some updated title"}

      assert {:ok, %{update: %List{} = list}} = Tasks.update_list(list, update_attrs)
      assert list.archived == false
      assert list.title == "some updated title"
    end

    test "update_list/2 with invalid data returns error changeset" do
      list = list_fixture() |> Repo.preload(:items)
      assert {:error, _op, %Ecto.Changeset{}, _acc} = Tasks.update_list(list, @invalid_attrs)
      assert list == Tasks.get_list!(list.id)
    end

    test "switch_list_archived/1 switches the list `archived` flag" do
      list = list_fixture(%{archived: false})

      assert {:ok, %List{} = list} = Tasks.switch_list_archived(list)
      assert list.archived == true

      assert {:ok, %List{} = list} = Tasks.switch_list_archived(list)
      assert list.archived == false
    end

    test "change_list/1 returns a list changeset" do
      assert %Ecto.Changeset{} = Tasks.change_list(:new)

      list = list_fixture()
      assert %Ecto.Changeset{} = Tasks.change_list(list)
    end

    test "archive_stale_lists/0" do
      list1 = list_fixture() |> Repo.preload(:items)
      list2 = list_fixture() |> Repo.preload(:items)
      list3 = list_fixture() |> Repo.preload(:items)
      list4 = list_fixture() |> Repo.preload(:items)

      Enum.each([list1, list2], &update_time_field(&1, :updated_at, {-1, :day}))

      Tasks.switch_list_archived(list3)

      list3 = Tasks.get_list!(list3.id)

      Tasks.archive_stale_lists()

      new_list1 = Tasks.get_list!(list1.id)
      new_list2 = Tasks.get_list!(list2.id)
      new_list3 = Tasks.get_list!(list3.id)
      new_list4 = Tasks.get_list!(list4.id)

      refute new_list1 == list1
      assert new_list1.archived

      refute new_list2 == list2
      assert new_list2.archived

      assert new_list3 == list3
      assert new_list3.archived

      assert new_list4 == list4
      refute new_list4.archived
    end
  end

  describe "items" do
    alias Todo.Tasks.List.Item

    import Todo.TasksFixtures

    @invalid_attrs %{completed: nil, content: nil}

    test "list_items/1 returns all items in the list ordered by inserted_at" do
      list1 = list_fixture()
      list2 = list_fixture()
      item1 = item_fixture(%{list_id: list1.id})
      item2 = item_fixture(%{list_id: list1.id})
      item3 = item_fixture(%{list_id: list1.id})
      item4 = item_fixture(%{list_id: list2.id})

      {:ok, updated_item2} = update_time_field(item2, :inserted_at, {-1, :minute})

      result = Tasks.list_items(list1.id)

      assert result == [item1, item3, updated_item2]
      refute item4 in result
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Tasks.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      list = list_fixture()
      valid_attrs = %{completed: true, content: "some content", list_id: list.id}

      assert {:ok, %{item: %Item{} = item}} = Tasks.create_item(valid_attrs)
      assert item.completed == false
      assert item.content == "some content"
    end

    test "create_item/1 with invalid data returns error changeset" do
      list = list_fixture()
      invalid_attrs = Map.put(@invalid_attrs, :list_id, list.id)
      assert {:error, :item, %Ecto.Changeset{}, _acc} = Tasks.create_item(invalid_attrs)
    end

    test "create_item/1 does not create item in archived list" do
      list = list_fixture()
      {:ok, list} = Tasks.switch_list_archived(list)

      valid_attrs = %{completed: true, content: "some content", list_id: list.id}

      assert {:error, :list, %Ecto.Changeset{} = changeset, _acc} = Tasks.create_item(valid_attrs)

      assert Keyword.has_key?(changeset.errors, :archived)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      update_attrs = %{completed: false, content: "some updated content"}

      assert {:ok, %{item: %Item{} = item}} = Tasks.update_item(item, update_attrs)
      assert item.completed == false
      assert item.content == "some updated content"
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, :item, %Ecto.Changeset{}, _acc} = Tasks.update_item(item, @invalid_attrs)
      assert item == Tasks.get_item!(item.id)
    end

    test "switch_item_completed/1 switches the item `completed` flag" do
      item = item_fixture(%{completed: false})

      assert {:ok, %{item: %Item{} = item}} = Tasks.switch_item_completed(item)
      assert item.completed == true

      assert {:ok, %{item: %Item{} = item}} = Tasks.switch_item_completed(item)
      assert item.completed == false
    end

    test "change_item/1 returns a item changeset" do
      assert %Ecto.Changeset{} = Tasks.change_item(:new)

      item = item_fixture()
      assert %Ecto.Changeset{} = Tasks.change_item(item)
    end
  end
end
