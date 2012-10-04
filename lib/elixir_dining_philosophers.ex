defmodule ElixirDiningPhilosophers do
  def start do
    :ok = :application.start(:elixir_dining_philosophers)
  end
end
