defmodule TodoWeb.ListLive.ItemFormComponent do
  use TodoWeb, :live_component

  alias Todo.Tasks

  @impl true
  def update(%{item: item} = assigns, socket) do
    changeset = Tasks.change_item(item)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:list_id, item.list_id)}
  end

  @impl true
  def handle_event("validate", %{"item" => item_params}, socket) do
    changeset =
      socket.assigns.item
      |> Tasks.change_item(item_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"item" => item_params}, socket) do
    save_item(socket, socket.assigns.action, item_params)
  end

  defp save_item(socket, :edit, item_params) do
    case Tasks.update_item(socket.assigns.item, item_params) do
      {:ok, %{item: _item}} ->
        {:noreply,
         socket
         |> put_flash(:info, "Item updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, _step, %Ecto.Changeset{} = changeset, _acc} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_item(socket, :new, item_params) do
    item_params = Map.put(item_params, "list_id", socket.assigns.list_id)

    case Tasks.create_item(item_params) do
      {:ok, %{item: _item}} ->
        {:noreply,
         socket
         |> put_flash(:info, "Item created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, _step, %Ecto.Changeset{} = changeset, _acc} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
