defmodule DynamicSupervisorTerminate.GenServer do
  use GenServer
  alias DynamicSupervisorTerminate.DynamicSupervisor, as: DSstate
  require Logger

  def start_link(args) do
    {id, type} = {Map.get(args, :name), Map.get(args, :family)}
    GenServer.start_link(__MODULE__, default(id, type), name: via(id, type))
  end

  def child_spec(process_name) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [process_name]},
      restart: :transient,
      max_restarts: 4
    }
  end

  defp default(name, family) do
    %{name: name, family: family}
  end

  def push(element) do
    case DSstate.start_child(%{name: element.name, family: element.family}) do
      {:ok, _status, pid} -> GenServer.cast(pid, {:push, element})
      {:error, result} -> {:error, :push, result}
    end
  end

  def make_error(name) do
    case DSstate.get_plugin_pid(name) do
      {:ok, :get_plugin_pid, pid} ->
        GenServer.cast(pid, {:pop})
      {:error, :get_plugin_pid} ->
        {:error, :get, :not_found}
    end
  end

  def stop(name) do
    case DSstate.get_plugin_pid(name) do
      {:ok, :get_plugin_pid, pid} ->
        GenServer.cast(pid, {:delete})
      {:error, :get_plugin_pid} ->
        {:error, :get, :not_found}
    end
  end

  def delete_child(name) do
    case DSstate.get_plugin_pid(name) do
      {:ok, :get_plugin_pid, pid} ->
        DynamicSupervisor.terminate_child(DynamicSupervisorRunner, pid)

      {:error, :get_plugin_pid} ->
        {:error, :get, :not_found}
    end
  end

  @impl true
  def init(state) do
    Logger.info("#{Map.get(state, :name)} #{Map.get(state, :family)} was started")
    {:ok, state, {:continue, {:sync_with_database}}}
  end

  @impl true
  def handle_cast({:push, element}, _state) do
    {:noreply, element}
  end

  @impl true
  def handle_cast({:pop}, _state) do
    raise "error"
  end

  @impl true
  def handle_cast({:delete}, state) do
    {:stop, :normal, state}
  end

  @impl true
  def handle_continue({:sync_with_database}, _state) do
    {:noreply, DynamicSupervisorTerminate.sample_init(1)}
  end

  @impl true
  def terminate(reason, state) do
    Logger.warn("#{Map.get(state, :name)} #{Map.get(state, :family)} was Terminated,
      Reason of Terminate #{inspect(reason)}")
  end

  defp via(id, value) do
    {:via, Registry, {DynamicSupervisorTerminate.Registry, id, value}}
  end
end
