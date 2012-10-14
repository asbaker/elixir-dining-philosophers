defmodule ElixirDiningPhilosophers do
  # def start do
  #   :ok = :application.start(:elixir_dining_philosophers)
  # end

  def dead_locking_scenario do
    :ok = :application.start(:elixir_dining_philosophers)

    fork1 = Fork.create_fork
    fork2 = Fork.create_fork
    fork3 = Fork.create_fork
    fork4 = Fork.create_fork
    fork5 = Fork.create_fork

    philosopher_list = []
    philosopher_list = List.concat(philosopher_list, [Philosopher.DeadLocking.start_new_philosopher("Aristotle", fork1, fork2)])
    philosopher_list = List.concat(philosopher_list, [Philosopher.DeadLocking.start_new_philosopher("Kant", fork2, fork3)])
    philosopher_list = List.concat(philosopher_list, [Philosopher.DeadLocking.start_new_philosopher("Marx", fork3, fork4)])
    philosopher_list = List.concat(philosopher_list, [Philosopher.DeadLocking.start_new_philosopher("Spinoza", fork4, fork5)])
    philosopher_list = List.concat(philosopher_list, [Philosopher.DeadLocking.start_new_philosopher("Russell", fork5, fork1)])

    # lock down the simulation to 3 minutes
    :timer.sleep(:timer.minutes(3))

    Enum.each(philosopher_list, &1 <- {:report_and_exit, self})

    wait_for_all_to_exit(philosopher_list)
    :ok = :application.stop(:elixir_dining_philosophers)
  end

  def starving_scenario do
    :ok = :application.start(:elixir_dining_philosophers)

    fork1 = Fork.create_fork
    fork2 = Fork.create_fork
    fork3 = Fork.create_fork
    fork4 = Fork.create_fork
    fork5 = Fork.create_fork

    philosopher_list = []
    philosopher_list = List.concat(philosopher_list, [Philosopher.DeadLocking.start_new_philosopher("Aristotle", fork1, fork2)])
    :timer.sleep(:timer.seconds(1))
    philosopher_list = List.concat(philosopher_list, [Philosopher.DeadLocking.start_new_philosopher("Kant", fork2, fork3)])
    philosopher_list = List.concat(philosopher_list, [Philosopher.DeadLocking.start_new_philosopher("Marx", fork3, fork4)])
    :timer.sleep(:timer.seconds(1))
    philosopher_list = List.concat(philosopher_list, [Philosopher.DeadLocking.start_new_philosopher("Spinoza", fork4, fork5)])
    philosopher_list = List.concat(philosopher_list, [Philosopher.DeadLocking.start_new_philosopher("Russell", fork5, fork1)])

    # lock down the simulation to 3 minutes
    :timer.sleep(:timer.minutes(3))

    Enum.each(philosopher_list, &1 <- {:report_and_exit, self})

    wait_for_all_to_exit(philosopher_list)
    :ok = :application.stop(:elixir_dining_philosophers)
  end

  def non_locking do
    :ok = :application.start(:elixir_dining_philosophers)

    fork1 = Fork.create_fork
    fork2 = Fork.create_fork
    fork3 = Fork.create_fork
    fork4 = Fork.create_fork
    fork5 = Fork.create_fork

    philosopher_list = []
    philosopher_list = List.concat(philosopher_list, [Philosopher.NonLocking.start_new_philosopher("Aristotle", fork1, fork2)])
    philosopher_list = List.concat(philosopher_list, [Philosopher.NonLocking.start_new_philosopher("Kant", fork2, fork3)])
    philosopher_list = List.concat(philosopher_list, [Philosopher.NonLocking.start_new_philosopher("Marx", fork3, fork4)])
    philosopher_list = List.concat(philosopher_list, [Philosopher.NonLocking.start_new_philosopher("Spinoza", fork4, fork5)])
    philosopher_list = List.concat(philosopher_list, [Philosopher.NonLocking.start_new_philosopher("Russell", fork5, fork1)])

    # lock down the simulation to 3 minutes
    :timer.sleep(:timer.minutes(3))

    Enum.each(philosopher_list, &1 <- {:report_and_exit, self})

    wait_for_all_to_exit(philosopher_list)
    :ok = :application.stop(:elixir_dining_philosophers)
  end



  defp wait_for_all_to_exit(watch_list) do
    all_done = Enum.all?(Enum.map(watch_list, Process.alive?(&1)), &1 == false)

    if !all_done do
      :timer.sleep(500)
      wait_for_all_to_exit(watch_list)
    end
  end
end
