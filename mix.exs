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
  defmodule Deadlock do
    use Mix.Task

    @shortdoc "start up the dead locking scenario"

    def run(_) do
      Mix.Task.run("run", ["ElixirDiningPhilosophers.dead_locking_scenario()"])
    end
  end

  defmodule Nonlocking do
    use Mix.Task

    @shortdoc "start up the non locking scenario"

    def run(_) do
      Mix.Task.run("run", ["ElixirDiningPhilosophers.non_locking"])
    end
  end
end

