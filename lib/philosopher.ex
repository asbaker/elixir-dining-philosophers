defmodule Philosopher do
  defrecord PhilosopherRecord, name: nil, left_fork: nil, right_fork: nil, status: :waiting, times_eaten: 0

  defmodule DeadLocking do
    def start_philosopher(philosopher) do
      spawn fn -> run_loop(philosopher) end
    end

    def run_loop(philosopher) do
      :random.seed(:erlang.now)

      # Dead locking philosopher:
      # One idea is to instruct each philosopher to behave as follows:
      # think until the left fork is available and when it is pick it up
      # think until the right fork is available and when it is pick it up
      # eat for a fixed amount of time
      # put the right fork down
      # put the left fork down
      # repeat from the beginning

      if Fork.is_fork_available(philosopher.left_fork) do
        Fork.take_fork(philosopher.left_fork)
      else
        Philosopher.think(philosopher)
      end

      if Fork.is_fork_available(philosopher.right_fork) do
        Fork.take_fork(philosopher.right_fork)
      else
        Philosopher.think(philosopher)
      end

      if Fork.is_fork_mine(philosopher.left_fork) and Fork.is_fork_mine(philosopher.right_fork) do
        philosopher = Philosopher.eat(philosopher)
        Fork.return_fork(philosopher.left_fork)
        Fork.return_fork(philosopher.right_fork)
      end

      receive do
        {:report_and_exit, from} ->
          IO.puts("**** #{philosopher.name} has eaten #{philosopher.times_eaten}\n")
          Fork.return_fork(philosopher.left_fork)
          Fork.return_fork(philosopher.right_fork)
          Process.exit(self, :kill)
      after 0 ->
        run_loop(philosopher)
      end
    end
  end


  defmodule NonLocking do
    def start_philosopher(philosopher) do
      spawn fn -> run_loop(philosopher) end
    end

    def run_loop(philosopher) do
      :random.seed(:erlang.now)

      # Each philosopher flips a coin.
      # Heads, he picks up the right chopstick first, tails, the left.
      # If the second chopstick is busy, he puts down the first and tries again.
      # With probability 1, he will eventually eat.
      # Again, this solution relies on defeating circular waiting whenever possible and then resorts to breaking 'acquiring while holding' as assurance for the case when two adjacent philosophers' coins both come up the same.
      # Again, this solution is fair and ensures all philosophers can eat eventually.

      right_first = :random.uniform(2) == 1
      first_fork = philosopher.right_fork
      second_fork = philosopher.left_fork

      if !right_first do
        first_fork = philosopher.left_fork
        second_fork = philosopher.right_fork
      end

      if Fork.take_fork(first_fork) do
        if Fork.take_fork(second_fork) do
          philosopher = Philosopher.eat(philosopher)

          Fork.return_fork(second_fork)
          Fork.return_fork(first_fork)
        else
          Fork.return_fork(first_fork)
          Philosopher.think(philosopher)
        end
      end

      receive do
        {:report_and_exit, from} ->
          IO.puts("**** #{philosopher.name} has eaten #{philosopher.times_eaten}\n")
          Fork.return_fork(philosopher.left_fork)
          Fork.return_fork(philosopher.right_fork)
          Process.exit(self, :kill)
      after 0 ->
        run_loop(philosopher)
      end
    end
  end

  def think(philosopher) do
    time = :random.uniform(2000)
    IO.puts("#{philosopher.name} is thinking for #{time} milliseconds\n")

    :timer.sleep(time)
  end

  def eat(philosopher) do
    time = :random.uniform(2000)
    IO.puts("#{philosopher.name} is eating for #{time} milliseconds, #{philosopher.name} has eaten #{philosopher.times_eaten}\n")

    :timer.sleep(time)
    philosopher.increment_times_eaten
  end
end
