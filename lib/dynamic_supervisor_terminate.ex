defmodule DynamicSupervisorTerminate do
  def sample_init(number) do
    if number == 1, do: shahryar(), else: mishka()
  end

  defp shahryar do
    %{name: "Shahryar", family: "Tavakkoli"}
  end

  defp mishka do
    %{name: "Mishka", family: "Group"}
  end
end
