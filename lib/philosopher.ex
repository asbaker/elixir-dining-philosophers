defmodule Philosopher do



# Dead locking philosopher:
# One idea is to instruct each philosopher to behave as follows:
# think until the left fork is available and when it is pick it up
# think until the right fork is available and when it is pick it up
# eat for a fixed amount of time
# put the right fork down
# put the left fork down
# repeat from the beginning


# non dead locking philosopher
# Each philosopher flips a coin.
# Heads, he picks up the right chopstick first, tails, the left.
# If the second chopstick is busy, he puts down the first and tries again.
# With probability 1, he will eventually eat.
# Again, this solution relies on defeating circular waiting whenever possible and then resorts to breaking 'acquiring while holding' as assurance for the case when two adjacent philosophers' coins both come up the same.
# Again, this solution is fair and ensures all philosophers can eat eventually.

end
