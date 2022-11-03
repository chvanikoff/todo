defmodule Todo.Cleanup do
  use GenServer

  @impl true
  def init(_opts) do
    {:ok, nil}
  end

  @impl true
  def handle_info(:run, state) do
    :ok = Tasks.archive_stale_lists()
    {:noreply, state}
  end
end
