defmodule Todo.Cleanup do
  @moduledoc """
  Cleanup server that runs periodically to archive stale lists
  """
  use GenServer

  alias Todo.Tasks

  def start_link([args]) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(interval) do
    _tref = schedule_run(self(), interval)
    {:ok, interval}
  end

  @impl true
  def handle_info(:run, interval) do
    {_num_rows, nil} = Tasks.archive_stale_lists()
    _tref = schedule_run(self(), interval)

    {:noreply, interval}
  end

  defp schedule_run(pid, interval) do
    Process.send_after(pid, :run, interval)
  end
end
