defmodule DynamicSupervisorTerminate.DynamicSupervisor do
  alias DynamicSupervisorTerminate.GenServer, as: GSstate
  alias DynamicSupervisorTerminate.Registry, as: RGstate

  def start_child(args) do
    DynamicSupervisor.start_child(DynamicSupervisorRunner, {GSstate, args})
    |> case do
      {:ok, pid} -> {:ok, :add, pid}
      {:ok, pid, _any} -> {:ok, :add, pid}
      {:error, {:already_started, pid}} -> {:ok, :edit, pid}
      {:error, result} -> {:error, result}
    end
  end

  def running_imports(), do: registery()

  defp registery(guards \\ []) do
    {match_all, map_result} = {
      {:"$1", :"$2", :"$3"},
      [%{id: :"$1", pid: :"$2", type: :"$3"}]
    }

    Registry.select(RGstate, [{match_all, guards, map_result}])
  end

  def get_plugin_pid(name) do
    case Registry.lookup(RGstate, name) do
      [] -> {:error, :get_plugin_pid}
      [{pid, _type}] -> {:ok, :get_plugin_pid, pid}
    end
  end
end
