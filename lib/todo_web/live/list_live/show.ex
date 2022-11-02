defmodule TodoWeb.ListLive.Show do
  use TodoWeb, :live_view

  alias Todo.Tasks
  alias Todo.Tasks.List.Item

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"list_id" => list_id} = params, _url, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:list, Tasks.get_list!(list_id))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"item_id" => id}) do
    socket
    |> assign(:item, Tasks.get_item!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:item, %Item{list_id: socket.assigns.list.id})
  end

  defp apply_action(socket, :show, _params) do
    socket
    |> assign(:item, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    item = Tasks.get_item!(id)
    {:ok, _} = Tasks.delete_item(item)

    {:noreply, assign(socket, :list, Tasks.get_list!(socket.assigns.list.id))}
  end

  defp page_title(:show), do: "Show List"
  defp page_title(:new), do: "New Item"
  defp page_title(:edit), do: "Edit Item"
end
