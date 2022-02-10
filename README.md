# DynamicSupervisorTerminate

```elixir
DynamicSupervisorTerminate.GenServer.push(DynamicSupervisorTerminate.sample_init(1))
DynamicSupervisorTerminate.DynamicSupervisor.running_imports()
DynamicSupervisorTerminate.GenServer.make_error(DynamicSupervisorTerminate.sample_init(1).name)
DynamicSupervisorTerminate.GenServer.stop(DynamicSupervisorTerminate.sample_init(1).name)
or
DynamicSupervisorTerminate.GenServer.delete_child(DynamicSupervisorTerminate.sample_init(1).name)
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `dynamic_supervisor_terminate` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:dynamic_supervisor_terminate, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/dynamic_supervisor_terminate>.

