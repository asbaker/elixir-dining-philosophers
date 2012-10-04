Code.require_file "../test_helper.exs", __FILE__

defmodule ElixirDiningPhilosophersTest do
  use ExUnit.Case

  test "forks can be spawned" do
    fork1 = Fork.create_fork
    fork2 = Fork.create_fork
    fork3 = Fork.create_fork

    assert is_pid fork1
    assert Process.alive?(fork1)

    assert is_pid fork2
    assert Process.alive?(fork2)

    assert is_pid fork3
    assert Process.alive?(fork3)
  end

  test "fork can be queried" do
    fork1 = Fork.create_fork

    assert !Fork.is_fork_taken(fork1)
  end

  test "fork can be queried repeatedly" do
    fork1 = Fork.create_fork

    assert !Fork.is_fork_taken(fork1)
    assert !Fork.is_fork_taken(fork1)
  end

  test "forks can be killed" do
    fork1 = Fork.create_fork
    fork2 = Fork.create_fork

    assert is_pid fork1
    assert Process.alive?(fork1)
    assert is_pid fork2
    assert Process.alive?(fork2)

    Fork.kill_fork(fork1)
    assert !Process.alive?(fork1)
    assert Process.alive?(fork2)

    Fork.kill_fork(fork2)
    assert !Process.alive?(fork2)
  end

  test "forks can be taken" do
    fork1 = Fork.create_fork
    fork2 = Fork.create_fork

    assert !Fork.is_fork_taken(fork1)
    assert !Fork.is_fork_taken(fork2)

    Fork.take_fork(fork1)

    assert Fork.is_fork_taken(fork1)
    assert !Fork.is_fork_taken(fork2)

    Fork.take_fork(fork2)
    assert Fork.is_fork_taken(fork1)
    assert Fork.is_fork_taken(fork2)
  end

  test "forks can be returned" do
    fork1 = Fork.create_fork
    fork2 = Fork.create_fork

    Fork.take_fork(fork1)
    Fork.take_fork(fork2)

    Fork.return_fork(fork1)
    assert !Fork.is_fork_taken(fork1)
    assert Fork.is_fork_taken(fork2)

    Fork.return_fork(fork2)
    assert !Fork.is_fork_taken(fork1)
    assert !Fork.is_fork_taken(fork2)
  end

  test "forks can not be stolen" do
    fork1 = Fork.create_fork

    Fork.take_fork(fork1)
    assert Fork.is_fork_taken(fork1)

    current_process = Process.self
    Process.spawn fn -> 
      current_process <- Fork.return_fork(fork1) == false && Fork.take_fork(fork1) == false
    end

    receive do
      val -> 
        assert val == true
      after 1000 ->
        raise "Spawned assertion not responding"
    end

    assert Fork.is_fork_taken(fork1)

    Fork.return_fork(fork1)
    assert !Fork.is_fork_taken(fork1)
  end
end
