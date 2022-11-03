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

      day_ago =
        NaiveDateTime.utc_now()
        |> NaiveDateTime.add(-1, :day)
        |> NaiveDateTime.truncate(:second)

      Enum.each([list1, list2], fn list ->
        list
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.force_change(:updated_at, day_ago)
        |> Todo.Repo.update()
      end)

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

      day_ago =
        NaiveDateTime.utc_now()
        |> NaiveDateTime.add(-1, :day)
        |> NaiveDateTime.truncate(:second)

      list1
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.force_change(:updated_at, day_ago)
      |> Todo.Repo.update()

      {:ok, _pid} = start_supervised({Todo.Cleanup, [100]})

      Process.sleep(150)

      new_list1 = Tasks.get_list!(list1.id)

      refute new_list1 == list1
      assert new_list1.archived

      list2 = list_fixture() |> Repo.preload(:items)

      day_ago =
        NaiveDateTime.utc_now()
        |> NaiveDateTime.add(-1, :day)
        |> NaiveDateTime.truncate(:second)

      list2
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.force_change(:updated_at, day_ago)
      |> Todo.Repo.update()

      Process.sleep(150)

      new_list2 = Tasks.get_list!(list2.id)

      refute new_list2 == list2
      assert new_list2.archived
    end
  end
end
