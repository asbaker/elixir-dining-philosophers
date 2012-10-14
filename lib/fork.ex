defmodule Fork do
  def create_fork do
    spawn fn -> Fork.start_fork(false, nil) end
  end

  def start_fork(taken, owner) do
    receive do
      {:query, pid} ->
        send_reply(pid, :query, taken)
        start_fork(taken, owner)
      {:mine, pid} ->
        send_reply(pid, :mine, pid == owner)
        start_fork(taken, owner)
      {:take, pid} ->
        if !taken do
          send_reply(pid, :take, :ok)
          start_fork(true, pid)
        else
          send_reply(pid, :take, :fail)
          start_fork(taken, owner)
        end
      {:return, pid} ->
        if taken && pid == owner do
          send_reply(pid, :return, :ok)
          start_fork(false, nil)
        else
          send_reply(pid, :return, :fail)
          start_fork(taken, owner)
        end
      {:kill, pid} ->
        send_reply(pid, :kill, :ok)
    end
  end


  # Client helper methods
  def is_fork_taken(fork) do
    send_to_fork(fork, :query)
    receive_response(:query, fork)
  end

  def is_fork_available(fork) do
    not is_fork_taken(fork)
  end

  def is_fork_mine(fork) do
    send_to_fork(fork, :mine)
    receive_response(:mine, fork)
  end

  def kill_fork(fork) do
    send_to_fork(fork, :kill)
    receive_response(:kill, fork) == :ok
  end

  def take_fork(fork) do
    send_to_fork(fork, :take)
    receive_response(:take, fork) == :ok
  end

  def return_fork(fork) do
    send_to_fork(fork, :return)
    receive_response(:return, fork) == :ok
  end


  # Private
  defp send_reply(who, action, result) do
    who <- {action, result, Process.self}
  end

  defp send_to_fork(fork, msg) do
    fork <- {msg, Process.self}
  end

  defp receive_response(action, from) do
    receive do
      {action, result, from} ->
        result
      after 1000 ->
        raise "Fork not responding"
    end
  end

end
