defmodule UndiWeb.StripeWebhookController do
  @moduledoc """
  This Controller is the entrypoint for receiving webhooks from Stripe.
  Setup the webhoks in Stripe and let them post to /webhooks/stripe
  """
  use UndiWeb, :controller

  import Undi.Billing.Stripe.StripeService

  plug :assert_body_and_signature

  def create(conn, _params) do
    stripe_service(:webhook_construct_event, [
      raw_body: conn.assigns[:raw_body],
      stripe_signature: conn.assigns[:stripe_signature],
      webhook_signing_key: webhook_signing_key()
    ])
    |> case do
      {:ok, %{} = event} -> notify_subscribers(event)
      {:error, reason} -> reason
    end

    conn
    |> send_resp(:created, "")
  end

  def notify_subscribers(event) do
    Phoenix.PubSub.broadcast(Undi.PubSub, "webhook_received", %{event: event})
  end

  def subscribe_on_webhook_recieved do
    Phoenix.PubSub.subscribe(Undi.PubSub, "webhook_received")
  end

  defp webhook_signing_key, do: Application.get_env(:stripity_stripe, :webhook_signing_key)

  defp assert_body_and_signature(conn, _opts) do
    case {conn.assigns[:raw_body], conn.assigns[:stripe_signature]} do
      {"" <> _, "" <> _} ->
        conn
      _ ->
        conn
        |> send_resp(:created, "")
        |> halt()
    end
  end
end
