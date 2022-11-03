defmodule TodoWeb.ListLiveTest do
  use TodoWeb.ConnCase

  import Phoenix.LiveViewTest
  import Todo.TasksFixtures

  @create_attrs %{title: "some title"}
  @update_attrs %{title: "some updated title"}
  @invalid_attrs %{title: nil}

  defp create_list(_) do
    list = list_fixture()
    %{list: list}
  end

  describe "Index" do
    test "lists all lists", %{conn: conn} do
      list = list_fixture()
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

    test "Broadcasts new list creation", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.list_index_path(conn, :index))

      conn2 = Phoenix.ConnTest.build_conn()
      {:ok, index_live2, _html} = live(conn2, Routes.list_index_path(conn2, :index))

      refute render(index_live2) =~ @create_attrs.title

      index_live
      |> element("a", "New List")
      |> render_click()

      index_live
      |> form("#list-form", list: @create_attrs)
      |> render_submit()

      assert render(index_live2) =~ @create_attrs.title
    end

    test "updates list in listing", %{conn: conn} do
      list = list_fixture()
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

    test "Broadcasts list updates", %{conn: conn} do
      list = list_fixture()
      {:ok, index_live, _html} = live(conn, Routes.list_index_path(conn, :index))

      conn2 = Phoenix.ConnTest.build_conn()
      {:ok, index_live2, _html} = live(conn2, Routes.list_index_path(conn2, :index))

      refute render(index_live2) =~ @update_attrs.title

      index_live
      |> element("#list-#{list.id} a", "Edit")
      |> render_click()

      index_live
      |> form("#list-form", list: @update_attrs)
      |> render_submit()

      assert render(index_live2) =~ @update_attrs.title
    end

    test "switches list `archived` flag back and forth", %{conn: conn} do
      list = list_fixture(%{archived: false})
      {:ok, index_live, _html} = live(conn, Routes.list_index_path(conn, :index))

      assert index_live
             |> element("#list-#{list.id} input[type=checkbox]")
             |> render_click() =~ "checked=\"checked\""

      refute index_live
             |> element("#list-#{list.id} input[type=checkbox]")
             |> render_click() =~ "checked=\"checked\""
    end

    test "Broadcasts list archived state updates", %{conn: conn} do
      list = list_fixture()
      {:ok, index_live, _html} = live(conn, Routes.list_index_path(conn, :index))

      conn2 = Phoenix.ConnTest.build_conn()
      {:ok, index_live2, _html} = live(conn2, Routes.list_index_path(conn2, :index))

      refute index_live2
             |> element("#list-#{list.id} input[type=checkbox]")
             |> render() =~ "checked=\"checked\""

      index_live
      |> element("#list-#{list.id} input[type=checkbox]")
      |> render_click()

      assert index_live2
             |> element("#list-#{list.id} input[type=checkbox]")
             |> render() =~ "checked=\"checked\""
    end
  end

  describe "Show" do
    setup [:create_list]

    @create_attrs %{content: "some content"}
    @update_attrs %{content: "some updated content"}
    @invalid_attrs %{content: nil}

    test "displays all items in the list", %{conn: conn, list: list} do
      item1 = item_fixture(%{list_id: list.id})
      item2 = item_fixture(%{list_id: list.id})

      {:ok, _show_live, html} = live(conn, Routes.list_show_path(conn, :show, list))

      assert html =~ "Show List"
      assert html =~ list.title
      assert html =~ item1.content
      assert html =~ item2.content
    end

    test "saves new item", %{conn: conn, list: list} do
      {:ok, index_live, _html} = live(conn, Routes.list_show_path(conn, :show, list))

      assert index_live |> element("a", "New Item") |> render_click() =~
               "New Item"

      assert_patch(index_live, Routes.list_show_path(conn, :new, list))

      assert index_live
             |> form("#item-form", item: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#item-form", item: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.list_show_path(conn, :show, list))

      assert html =~ "Item created successfully"
      assert html =~ "some content"
    end

    test "updates item in listing", %{conn: conn, list: list} do
      item = item_fixture(%{list_id: list.id})

      {:ok, index_live, _html} = live(conn, Routes.list_show_path(conn, :show, list))

      assert index_live |> element("#item-#{item.id} a", "Edit") |> render_click() =~
               "Edit Item"

      assert_patch(index_live, Routes.list_show_path(conn, :edit, list, item))

      assert index_live
             |> form("#item-form", item: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#item-form", item: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.list_show_path(conn, :show, list))

      assert html =~ "Item updated successfully"
      assert html =~ "some updated content"
    end

    test "switches item `completed` flag back and forth", %{conn: conn, list: list} do
      item = item_fixture(%{list_id: list.id, completed: false})
      {:ok, index_live, _html} = live(conn, Routes.list_show_path(conn, :show, list))

      assert index_live
             |> element("#item-#{item.id} input[type=checkbox]")
             |> render_click() =~ "checked=\"checked\""

      refute index_live
             |> element("#item-#{item.id} input[type=checkbox]")
             |> render_click() =~ "checked=\"checked\""
    end
  end
end
