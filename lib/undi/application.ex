defmodule Undi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      UndiWeb.Telemetry,
      # Start the Ecto repository
      Undi.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Undi.PubSub},
      # Start Finch
      {Finch, name: Undi.Finch},
      # Start the Endpoint (http/https)
      UndiWeb.Endpoint,
      # Start a worker by calling: Undi.Worker.start_link(arg)
      # {Undi.Worker, arg}
      webhook_processor_service(),
      {Oban, oban_config()},
      {Cachex, name: :general_cache}, # You can add additional caches with different names

    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Undi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UndiWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp oban_config do
    Application.fetch_env!(:undi, Oban)
  end

  # Dont start the genserver in test mode
  defp webhook_processor_service do
    if Application.get_env(:undi, :env) == :test,
      do: Undi.Billing.Stripe.WebhookProcessor.Stub,
      else: Undi.Billing.Stripe.WebhookProcessor
  end
end
