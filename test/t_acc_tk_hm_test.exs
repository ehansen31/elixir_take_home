defmodule TAccTkHmTest do
  use ExUnit.Case
  import Mock
  doctest TAccTkHm

  test "consolidates payments" do
    vals = TAccTkHm.consolidate_payments([%{payment_plan_id: 0,
    amount: 51.25,
    date: "2020-09-29T17:19:31Z"},%{payment_plan_id: 0,
    amount: 17.25,
    date: "2020-09-29T17:19:31Z"} ])

    assert %{0 => 68.5} = vals
  end

  test "gets debts in payment plans" do
    vals = TAccTkHm.debts_in_payment_plans([%{id: 0,
    debt_id: 0,
    amount_to_pay: 102.50,
    installment_frequency: "WEEKLY",
    installment_amount: 51.25,
    start_date: "2020-09-28T16:18:30Z"}])

    assert %{0 => true} = vals
  end

  test "gets payment frequencies" do
    vals = TAccTkHm.payment_frequencies([%{  id: 0,
    debt_id: 0,
    amount_to_pay: 102.50,
    installment_frequency: "WEEKLY",
    installment_amount: 51.25,
    start_date: "2020-09-28T16:18:30Z"}])

    assert %{0 => "WEEKLY"} = vals
  end

  test "gets next payment date" do
    vals = TAccTkHm.next_payment_dates([%{
      payment_plan_id: 0,
      amount: 51.25,
      date: "2019-09-29T17:19:31Z"
    },%{
      payment_plan_id: 0,
      amount: 51.25,
      date: "2020-08-01"
    },%{
      payment_plan_id: 0,
      amount: 51.25,
      date: "2019-09-29T17:19:31Z"
    }], %{0 => "WEEKLY"})

    assert %{0 => "2020-08-08T00:00:00Z"} = vals
  end
end
