defmodule DynamicSupervisorTerminate.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    runner_config = [
      strategy: :one_for_one,
      name: DynamicSupervisorRunner
    ]

    children = [
      {Registry, keys: :unique, name: DynamicSupervisorTerminate.Registry},
      {DynamicSupervisor, runner_config}
    ]

    opts = [strategy: :one_for_one, name: DynamicSupervisorTerminate.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
