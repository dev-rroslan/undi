defmodule UndiWeb.Admin.SubscriptionLive.Show do
  @moduledoc """
  The admin subscription show page.
  """
  use UndiWeb, :live_view

  alias Undi.Billing

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    subscription = Billing.get_subscription!(id)

    {:noreply,
     socket
     |> assign(:page_title, "Show Subscription")
     |> assign(:subscription, subscription)}
  end
end
