defmodule Todo.CleanupTest do
  use Todo.DataCase

  import Todo.TasksFixtures

  alias Todo.Tasks

  describe "cleanup server" do
    test "archives stale lists" do
      list1 = list_fixture() |> Repo.preload(:items)
      list2 = list_fixture() |> Repo.preload(:items)
      list3 = list_fixture() |> Repo.preload(:items)
      list4 = list_fixture() |> Repo.preload(:items)

      Enum.each([list1, list2], &update_time_field(&1, :updated_at, {-1, :day}))

      Tasks.switch_list_archived(list3)

      list3 = Tasks.get_list!(list3.id)

      {:ok, _pid} = start_supervised({Todo.Cleanup, [100]})

      Process.sleep(150)

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

    test "runs repeatedly" do
      list1 = list_fixture() |> Repo.preload(:items)

      update_time_field(list1, :updated_at, {-1, :day})

      {:ok, _pid} = start_supervised({Todo.Cleanup, [100]})

      Process.sleep(150)

      new_list1 = Tasks.get_list!(list1.id)

      refute new_list1 == list1
      assert new_list1.archived

      list2 = list_fixture() |> Repo.preload(:items)

      update_time_field(list2, :updated_at, {-1, :day})

      Process.sleep(150)

      new_list2 = Tasks.get_list!(list2.id)

      refute new_list2 == list2
      assert new_list2.archived
    end
  end
end
