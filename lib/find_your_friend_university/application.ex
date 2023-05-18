defmodule FindYourFriendUniversity.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      FindYourFriendUniversityWeb.Telemetry,
      # Start the Ecto repository
      FindYourFriendUniversity.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: FindYourFriendUniversity.PubSub},
      # Start Finch
      {Finch, name: FindYourFriendUniversity.Finch},
      # Start the Endpoint (http/https)
      FindYourFriendUniversityWeb.Endpoint
      # Start a worker by calling: FindYourFriendUniversity.Worker.start_link(arg)
      # {FindYourFriendUniversity.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FindYourFriendUniversity.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FindYourFriendUniversityWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
