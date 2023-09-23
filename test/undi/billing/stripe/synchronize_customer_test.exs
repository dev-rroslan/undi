defmodule Undi.Billing.SynchronizeCustomerTest do
  use Undi.DataCase, async: true

  import Undi.BillingFixtures

  alias Undi.Billing.Stripe.SynchronizeCustomer

  describe "run" do
    test "run/1 syncs payment method from stripe and stores it on the customer" do
      customer = customer_fixture()

      refute customer.card_last4 == "4242"
      assert {:ok, customer} = SynchronizeCustomer.run(customer)
      assert customer.card_last4 == "4242"
    end
  end
end
