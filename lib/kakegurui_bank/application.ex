defmodule KakeguruiBank.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      KakeguruiBankWeb.Telemetry,
      # Start the Ecto repository
      KakeguruiBank.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: KakeguruiBank.PubSub},
      # Start Finch
      {Finch, name: KakeguruiBank.Finch},
      # Start the Endpoint (http/https)
      KakeguruiBankWeb.Endpoint
      # Start a worker by calling: KakeguruiBank.Worker.start_link(arg)
      # {KakeguruiBank.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KakeguruiBank.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KakeguruiBankWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
