defmodule Undi.Billing.Stripe.SynchronizeSubscriptions do
  @moduledoc """
  This module is responsible for getting data from Stripe
  and storing it in the database. It can be run manually or on a schedule.
  """
  import Undi.Billing.Stripe.StripeService

  alias Undi.Billing
  alias Undi.Billing.Stripe.Subscription
  alias Undi.Billing.Stripe.Plan

  defp get_all_subscriptions_from_stripe(opts) do
    {:ok, %{data: subscriptions}} = stripe_service(:list_subscriptions, opts)
    subscriptions
  end

  def run(opts \\ []) do
    get_all_subscriptions_from_stripe(opts)
    |> Enum.map(fn subscription ->
      Billing.create_or_update(Plan, subscription.plan)
      Billing.create_or_update(Subscription, subscription)
    end)
  end
end
