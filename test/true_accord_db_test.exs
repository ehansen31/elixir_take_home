defmodule TrueAccordDBTest do
    use ExUnit.Case
    import Mock
    doctest TrueAccordDB
  
    test "gets debts success" do
      with_mock HTTPoison, # with more time: would mock above the library level and abstract library away from code for maintainability
          [get: fn("https://my-json-server.typicode.com/druska/trueaccord-mock-payments-api/debts") ->
            {:ok, %HTTPoison.Response{status_code: 200, body: "[\n  {\n    \"amount\": 123.46,\n    \"id\": 0\n  }]"}} end] do
  
        {:ok, response}  = TrueAccordDB.debts()
        assert [%{amount: 123.46, id: 0}] = response
      end
    end
  
    test "gets debts 400 error" do
      with_mock HTTPoison,
          [get: fn("https://my-json-server.typicode.com/druska/trueaccord-mock-payments-api/debts") ->
            {:ok, %HTTPoison.Response{status_code: 400, body: "{\"error\": \"Server Error\"}"}} end] do
            
        {:error, response}  = TrueAccordDB.debts()
        assert %{error: "Server Error"} = response
      end
    end
  
    test "gets debts library error" do
      with_mock HTTPoison,
          [get: fn("https://my-json-server.typicode.com/druska/trueaccord-mock-payments-api/debts") ->
            {:ok, %HTTPoison.Error{reason: "Ouchie"}} end] do
            
        {:error, reason}  = TrueAccordDB.debts()
        assert "Ouchie" = reason
      end
    end
  end
  