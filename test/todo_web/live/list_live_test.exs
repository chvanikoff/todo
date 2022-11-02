defmodule TodoWeb.ListLiveTest do
  use TodoWeb.ConnCase

  import Phoenix.LiveViewTest
  import Todo.TasksFixtures

  @create_attrs %{archived: true, title: "some title"}
  @update_attrs %{archived: false, title: "some updated title"}
  @invalid_attrs %{archived: false, title: nil}

  defp create_list(_) do
    list = list_fixture()
    %{list: list}
  end

  describe "Index" do
    setup [:create_list]

    test "lists all lists", %{conn: conn, list: list} do
      {:ok, _index_live, html} = live(conn, Routes.list_index_path(conn, :index))

      assert html =~ "Listing Lists"
      assert html =~ list.title
    end

    test "saves new list", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.list_index_path(conn, :index))

      assert index_live |> element("a", "New List") |> render_click() =~
               "New List"

      assert_patch(index_live, Routes.list_index_path(conn, :new))

      assert index_live
             |> form("#list-form", list: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#list-form", list: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.list_index_path(conn, :index))

      assert html =~ "List created successfully"
      assert html =~ "some title"
    end

    test "updates list in listing", %{conn: conn, list: list} do
      {:ok, index_live, _html} = live(conn, Routes.list_index_path(conn, :index))

      assert index_live |> element("#list-#{list.id} a", "Edit") |> render_click() =~
               "Edit List"

      assert_patch(index_live, Routes.list_index_path(conn, :edit, list))

      assert index_live
             |> form("#list-form", list: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#list-form", list: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.list_index_path(conn, :index))

      assert html =~ "List updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes list in listing", %{conn: conn, list: list} do
      {:ok, index_live, _html} = live(conn, Routes.list_index_path(conn, :index))

      assert index_live |> element("#list-#{list.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#list-#{list.id}")
    end
  end

  describe "Show" do
    setup [:create_list]

    test "displays list", %{conn: conn, list: list} do
      {:ok, _show_live, html} = live(conn, Routes.list_show_path(conn, :show, list))

      assert html =~ "Show List"
      assert html =~ list.title
    end
  end
end
