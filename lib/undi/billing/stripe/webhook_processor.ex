defmodule Undi.Billing.Stripe.WebhookProcessor do
  @moduledoc """
  This GenServer subscripes on incoming webhooks and run the corresponding code.
  """
  use GenServer

  alias UndiWeb.StripeWebhookController
  alias Undi.Billing
  alias Undi.Billing.Stripe.SynchronizeProducts
  alias Undi.Billing.Stripe.SynchronizePlans
  alias Undi.Billing.Stripe.Subscription
  alias Undi.Billing.Stripe.Invoice
  alias Undi.Billing.Stripe.HandlePaymentMethods

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(state) do
    StripeWebhookController.subscribe_on_webhook_recieved()
    {:ok, state}
  end

  def handle_info(%{event: event}, state) do
    notify_subscribers(event)

    case event.type do
      "product." <> _ -> SynchronizeProducts.run()
      "plan." <> _ -> SynchronizePlans.run()
      "customer.subscription." <> _ -> Billing.create_or_update(Subscription, event.data.object)
      "invoice." <> _ -> Billing.create_or_update(Invoice, event.data.object)
      "payment_method.attached" -> HandlePaymentMethods.add_card_info(event.data.object)
      "payment_method.detached" -> HandlePaymentMethods.remove_card_info(event.data.object)
      _ -> nil
    end

    {:noreply, state}
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Undi.PubSub, "webhook_processed")
  end

  def notify_subscribers(event) do
    Phoenix.PubSub.broadcast(Undi.PubSub, "webhook_processed", {:event, event})
  end

  defmodule Stub do
    @moduledoc "This is only used in tests"
    use GenServer
    def start_link(_), do: GenServer.start_link(__MODULE__, nil)
    def init(state), do: {:ok, state}
  end
end
