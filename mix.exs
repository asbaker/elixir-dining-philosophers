defmodule ElixirDiningPhilosophers.Mixfile do
  use Mix.Project

  def project do
    [ app: :elixir_dining_philosophers,
      version: "0.0.1",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    []
  end
end

defmodule Mix.Tasks.Start do
  @shortdoc "use mix start.deadlock | start.nolock | start.starving"
  @moduledoc "use mix start.deadlock | start.nolock | start.starving"

  def run(_) do
    IO.puts "use mix start.deadlock | start.nolock | start.starving"
  end

  defmodule Starving do
    use Mix.Task

    @shortdoc "start up the starving scenario"

    def run(_) do
      Mix.Task.run("run", ["ElixirDiningPhilosophers.starving_scenario()"])
    end
  end

  defmodule Deadlock do
    use Mix.Task

    @shortdoc "start up the dead locking scenario"

    def run(_) do
      Mix.Task.run("run", ["ElixirDiningPhilosophers.dead_locking_scenario()"])
    end
  end

  defmodule Nolock do
    use Mix.Task

    @shortdoc "start up the non locking scenario"

    def run(_) do
      Mix.Task.run("run", ["ElixirDiningPhilosophers.non_locking"])
    end
  end
end

