defmodule Fork do
  def create_fork do
    spawn fn -> Fork.start_fork(false, nil) end
  end

  def start_fork(taken, owner) do
    receive do
      {:query, pid} ->
        pid <- {:query, taken, Process.self}
        start_fork(taken, owner)
      {:take, pid} ->
        if !taken do
          pid <- {:take, :ok, Process.self}
          start_fork(true, pid)
        else
          pid <- {:take, :fail, Process.self}
          start_fork(taken, owner)
        end
      {:return, pid} ->
        if taken && pid == owner do
          pid <- {:return, :ok, Process.self}
          start_fork(false, nil)
        else
          pid <- {:return, :fail, Process.self}
          start_fork(taken, owner)
        end
      {:kill, pid} ->
        pid <- {:kill, :ok, Process.self}
    end
  end

  def send_to_fork(fork, msg) do
    fork <- {msg, Process.self}
  end

  def is_fork_taken(fork) do
    send_to_fork(fork, :query)

    receive do
      {:query, taken, fork} ->
        taken
      after 1000 ->
        raise "Fork not responding"
    end
  end

  def kill_fork(fork) do
    send_to_fork(fork, :kill)

    receive do
      {:kill, :ok, fork} ->
        true
      _ ->
        raise "Fork wasn't killed"
      after 1000 ->
        raise "Fork not responding"
    end
  end

  def take_fork(fork) do
    send_to_fork(fork, :take)

    receive do
      {:take, :ok, fork} ->
        true
      _ ->
        false
      after 1000 ->
        raise "Fork not responding"
    end
  end

  def return_fork(fork) do
    send_to_fork(fork, :return)

    receive do
      {:return, :ok, fork} ->
        true
      _ ->
        false
      after 1000 ->
        raise "Fork not responding"
    end
  end
end
