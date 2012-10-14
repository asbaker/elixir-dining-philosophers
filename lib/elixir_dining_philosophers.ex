defmodule ElixirDiningPhilosophers do
  # def start do
  #   :ok = :application.start(:elixir_dining_philosophers)
  # end

  def dead_locking_scenario do
    :ok = :application.start(:elixir_dining_philosophers)
    IO.puts "Dead locking!"
  end

  def non_locking do
    :ok = :application.start(:elixir_dining_philosophers)
    IO.puts "Non-locking!"
  end
end
