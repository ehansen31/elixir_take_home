defmodule TAccTkHm do
  require TrueAccordDB

  def start do
    {:ok, dbts_map} = TrueAccordDB.debts()
    {:ok, pymnt_plns_map} = TrueAccordDB.payment_plans()
    {:ok, pymnts_map} = TrueAccordDB.payments()

    IO.inspect pymnt_plns_map

    frqncs = pymnt_plns_map |> payment_frequencies
    dbts_in_plns = pymnt_plns_map |> debts_in_payment_plans
    cnsldtd_pymnts = pymnts_map |> consolidate_payments
    nxt_pymnt_dts = next_payment_dates(pymnts_map,  frqncs)

    Enum.reduce dbts_map, [], fn(dbt, out)->

      is_in_pln = dbts_in_plns[dbt.id]
      if nil == is_in_pln do
        is_in_pn = false
      end

      amt_pd = cnsldtd_pymnts[dbt.id]
      if amt_pd == nil do
        amt_pd = 0
      end

      nxt_pymnt_dt = nxt_pymnt_dts[dbt.id]
      
      {:ok, val} = Poison.encode %{"id": dbt.id, "amount": dbt.amount, "is_in_payment_plan": is_in_pln || false, remaining_amount: dbt.amount - (amt_pd||0) , "next_payment_due_date": nxt_pymnt_dt}

      IO.puts val
    end
  end

  def consolidate_payments(pymnts) do
    Enum.reduce pymnts, %{}, fn(pymnt, cnsldtd_pymnts)->
      case cnsldtd_pymnts[pymnt.payment_plan_id] do
        nil -> cnsldtd_pymnts = Map.put(cnsldtd_pymnts, pymnt.payment_plan_id, pymnt.amount)
        val -> cnsldtd_pymnts = Map.put(cnsldtd_pymnts, pymnt.payment_plan_id, pymnt.amount + val)
      end
    end
  end

  def debts_in_payment_plans(pymnt_plns) do
    Enum.reduce pymnt_plns, %{}, fn(pln, acc) ->
        Map.put(acc, pln.debt_id, true)
    end
  end

  def next_payment_dates(pymnts, pymnt_frqncs) do
    Enum.reduce pymnts, %{}, fn(pymnt, pymnt_schdl) ->
      {:ok, lst_pymnt} = DateTimeParser.parse_datetime(pymnt.date, assume_time: true, to_utc: true, parsers: [DateTimeParser.Parser.DateTime])
      {ok, lst_pymnt} = DateTime.from_naive(lst_pymnt, "Etc/UTC")

      nxt_time = case pymnt_frqncs do
        "BI_WEEKLY"-> DateTime.add(lst_pymnt, 302400, :seconds) # 3.5 days in seconds, crude but enough for this exercise
        _ -> DateTime.add(lst_pymnt, 604800, :seconds) # default weekly payment, in seconds
      end

      # pick the latest payment, not optimal
      case pymnt_schdl[pymnt.payment_plan_id] do
        nil -> Map.put(pymnt_schdl, pymnt.payment_plan_id, DateTime.to_iso8601(nxt_time))
        val ->
          {:ok, tm, _} = DateTime.from_iso8601(val)
          case DateTime.compare(tm, nxt_time) do
          :gt -> pymnt_schdl
          :eq -> pymnt_schdl
          :lt -> Map.put(pymnt_schdl, pymnt.payment_plan_id, DateTime.to_iso8601(nxt_time))
        end
      end
    end
  end

  def payment_frequencies(pymnt_plns) do
    Enum.reduce pymnt_plns, %{}, fn(pln, acc) ->
      Map.put(acc, pln.id, pln.installment_frequency)
  end
  end
end
