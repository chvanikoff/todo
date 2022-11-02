defmodule TodoWeb.ListLive.Index do
  use TodoWeb, :live_view

  alias Todo.Tasks
  alias Todo.Tasks.List

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    socket =
      socket
      |> assign(:lists, list_lists())
      |> apply_action(socket.assigns.live_action, params)

    {:noreply, socket}
  end

  defp apply_action(socket, :edit, %{"list_id" => id}) do
    socket
    |> assign(:page_title, "Edit List")
    |> assign(:list, Tasks.get_list!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New List")
    |> assign(:list, %List{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Lists")
    |> assign(:list, nil)
  end

  @impl true
  def handle_event("switch_archived", %{"id" => id}, socket) do
    list = Tasks.get_list!(id)
    {:ok, _new_list} = Tasks.switch_list_archived(list)

    {:noreply, assign(socket, :lists, list_lists())}
  end

  defp list_lists do
    Tasks.list_lists()
  end
end
