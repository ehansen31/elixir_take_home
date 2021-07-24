defmodule TrueAccordDB do
    require Logger
    @moduledoc """
    Documentation for `TAccTkHm`.
    """

    ## Examples
  """
    iex> TAccTkHm.debts()
    %{amount: 123.46, id: 0}
  """

  @base_url "https://my-json-server.typicode.com/druska/trueaccord-mock-payments-api"

    defp handle_response(resp) do
      case resp do
        {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
          Logger.info("handle_response: #{inspect(resp)}")
          Poison.decode(body, %{keys: :atoms})
        {:ok, %HTTPoison.Response{body: body}} ->
          Logger.warning("handle_response: #{inspect(resp)}")
          case Poison.decode(body, %{keys: :atoms}) do
            {:ok, val} -> {:error, val}
            _ -> {:error, "decode error"}
          end
         
        {:ok, %HTTPoison.Error{reason: reason}} ->
          Logger.error("handle_response: #{inspect(reason)}")
          {:error, reason}
      end
    end

    def debts do
      HTTPoison.get(@base_url <> "/debts")\
      |> handle_response
    end

    def payment_plans do
      HTTPoison.get(@base_url <> "/payment_plans")\
      |> handle_response
    end

    def payments do
      HTTPoison.get(@base_url <> "/payments")\
      |> handle_response
    end
  end
