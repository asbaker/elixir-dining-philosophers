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

    aristotle = Philosopher.DeadLocking.start_philosopher(Philosopher.PhilosopherRecord.new(name: "Aristotle", left_fork: fork1, right_fork: fork2))
    kant = Philosopher.DeadLocking.start_philosopher(Philosopher.PhilosopherRecord.new(name: "Kant", left_fork: fork2, right_fork: fork3))
    marx = Philosopher.DeadLocking.start_philosopher(Philosopher.PhilosopherRecord.new(name: "Marx", left_fork: fork4, right_fork: fork5))
    spinoza = Philosopher.DeadLocking.start_philosopher(Philosopher.PhilosopherRecord.new(name: "Spinoza", left_fork: fork3, right_fork: fork4))
    russell = Philosopher.DeadLocking.start_philosopher(Philosopher.PhilosopherRecord.new(name: "Russell", left_fork: fork5, right_fork: fork1))

    philosopher_list = [aristotle, kant, spinoza, marx, russell]

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

    aristotle = Philosopher.DeadLocking.start_philosopher(Philosopher.PhilosopherRecord.new(name: "Aristotle", left_fork: fork1, right_fork: fork2))
    :timer.sleep(:timer.seconds(1))
    marx = Philosopher.DeadLocking.start_philosopher(Philosopher.PhilosopherRecord.new(name: "Marx", left_fork: fork4, right_fork: fork5))
    kant = Philosopher.DeadLocking.start_philosopher(Philosopher.PhilosopherRecord.new(name: "Kant", left_fork: fork2, right_fork: fork3))
    :timer.sleep(:timer.seconds(1))
    russell = Philosopher.DeadLocking.start_philosopher(Philosopher.PhilosopherRecord.new(name: "Russell", left_fork: fork5, right_fork: fork1))
    spinoza = Philosopher.DeadLocking.start_philosopher(Philosopher.PhilosopherRecord.new(name: "Spinoza", left_fork: fork3, right_fork: fork4))

    philosopher_list = [aristotle, kant, spinoza, marx, russell]

    # lock down the simulation to 3 minutes
    :timer.sleep(:timer.minutes(3))

    Enum.each(philosopher_list, &1 <- {:report_and_exit, self})

    wait_for_all_to_exit(philosopher_list)
    :ok = :application.stop(:elixir_dining_philosophers)
  end

  def wait_for_all_to_exit(watch_list) do
    all_done = Enum.all?(Enum.map(watch_list, Process.alive?(&1)), &1 == false)

    if !all_done do
      :timer.sleep(500)
      wait_for_all_to_exit(watch_list)
    end
  end

  def non_locking do
    :ok = :application.start(:elixir_dining_philosophers)

    fork1 = Fork.create_fork
    fork2 = Fork.create_fork
    fork3 = Fork.create_fork
    fork4 = Fork.create_fork
    fork5 = Fork.create_fork

    aristotle = Philosopher.NonLocking.start_philosopher(Philosopher.PhilosopherRecord.new(name: "Aristotle", left_fork: fork1, right_fork: fork2))
    kant = Philosopher.NonLocking.start_philosopher(Philosopher.PhilosopherRecord.new(name: "Kant", left_fork: fork2, right_fork: fork3))
    spinoza = Philosopher.NonLocking.start_philosopher(Philosopher.PhilosopherRecord.new(name: "Spinoza", left_fork: fork3, right_fork: fork4))
    marx = Philosopher.NonLocking.start_philosopher(Philosopher.PhilosopherRecord.new(name: "Marx", left_fork: fork4, right_fork: fork5))
    russell = Philosopher.NonLocking.start_philosopher(Philosopher.PhilosopherRecord.new(name: "Russell", left_fork: fork5, right_fork: fork1))

    philosopher_list = [aristotle, kant, spinoza, marx, russell]

    # lock down the simulation to 3 minutes
    :timer.sleep(:timer.minutes(3))

    Enum.each(philosopher_list, &1 <- {:report_and_exit, self})

    wait_for_all_to_exit(philosopher_list)

    :ok = :application.stop(:elixir_dining_philosophers)
  end
end
