defmodule Philosopher do
  defrecord Philosopher, name: nil, left_fork: nil, right_fork: nil, status: :waiting, times_eaten: 0

  defmodule DeadLocking do
    def start_philosopher(philosopher) do
      spawn fn -> Philosopher.run_loop(philosopher) end
    end

    def run_loop(philosopher) do
        # Dead locking philosopher:
        # One idea is to instruct each philosopher to behave as follows:
        # think until the left fork is available and when it is pick it up
        # think until the right fork is available and when it is pick it up
        # eat for a fixed amount of time
        # put the right fork down
        # put the left fork down
        # repeat from the beginning

        if Fork.is_fork_available(philosopher.left_fork)  do
          Fork.take_fork(philosopher.left_fork)
          IO.puts "#{philosopher.name} took #{philosopher.left_fork}"
        else
          Philosopher.think(philosopher)
          run_loop(philosopher)
        end

        if Fork.is_fork_available(philosopher.right_fork)  do
          Fork.take_fork(philosopher.right_fork)
          IO.puts "#{philosopher.name} took #{philosopher.right_fork}"
        else
          Philosopher.think(philosopher)
          run_loop(philosopher)
        end

        if Fork.is_fork_mine(philosopher.left_fork) and Fork.is_fork_mine(philosopher.right_fork) do
          Philosopher.eat(philosopher)
          Fork.return_fork(philosopher.left_fork)
          IO.puts "#{philosopher.name} returned #{philosopher.left_fork}"

          Fork.return_fork(philosopher.right_fork)
          IO.puts "#{philosopher.name} returned #{philosopher.right_fork}"
        end

        run_loop(philosopher)
    end
  end


  # defimpl NonLocking do
  # def create_philosopher()
  # def start_philosopher(left_fork, right_fork)
# non dead locking philosopher
# Each philosopher flips a coin.
# Heads, he picks up the right chopstick first, tails, the left.
# If the second chopstick is busy, he puts down the first and tries again.
# With probability 1, he will eventually eat.
# Again, this solution relies on defeating circular waiting whenever possible and then resorts to breaking 'acquiring while holding' as assurance for the case when two adjacent philosophers' coins both come up the same.
# Again, this solution is fair and ensures all philosophers can eat eventually.
  # end


  def think(philosopher) do
    time = :random.uniform(10) * 1000
    IO.puts("#{philosopher.name} is sleeping for #{time} seconds")

    :timer.sleep(time)
  end

  def eat(philosopher) do
    time = :random.uniform(10) * 1000
    IO.puts("#{philosopher.name} is eating for #{time} seconds")

    :timer.sleep(time)
    philosopher.increment_times_eaten
  end
end
