defmodule Todo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        # Start the Ecto repository
        Todo.Repo,
        # Start the Telemetry supervisor
        TodoWeb.Telemetry,
        # Start the PubSub system
        {Phoenix.PubSub, name: Todo.PubSub},
        # Start the Endpoint (http/https)
        TodoWeb.Endpoint
      ] ++ env_children(Application.get_env(:todo, :env))

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Todo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TodoWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp env_children(:test), do: []

  defp env_children(_env) do
    cleanup_interval = Application.fetch_env!(:todo, :lists_cleanup)[:interval_in_seconds]
    [{Todo.Cleanup, [cleanup_interval]}]
  end
end
