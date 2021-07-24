# TAccTkHm

Approach was a data driven approach. Get the data from the db then begin breaking the problem down into functions as you build out from the data. Each step was unit tested before moving to the next step. 

Areas of improvement:
* Variable naming was done in GoLang fashion, would probably use full words in a non script for better readability, for a script it speeds things up.
* Documentation of functions
* Test coverage in db package
* Test coverage of more than happy path across the app
* Refactor and clean next_payment_dates function 
* Remove logic form start function into seperate functions
* Support a money type from the start, get rid of floating point arithmetic errors. (I added a library for money but didn't get around to using it.)
* db integration could use a wrapper around the http client so there isn't lock in to the library. 
* json parsing should be seperated out from handle_response



## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `t_acc_tk_hm` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:t_acc_tk_hm, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/t_acc_tk_hm](https://hexdocs.pm/t_acc_tk_hm).

