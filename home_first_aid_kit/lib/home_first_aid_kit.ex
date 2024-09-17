
defmodule HomeFirstAidKit do
  @moduledoc """
  Documentation for `HomeFirstAidKit`.
  """

  @doc """
  Add medicament to First-Aid Kit with increase amount
  """
  def add_medicament(%Medicament{name: name, amount: amount}) do
    storage = HomeFirstAidKitStorage.load()
    existing = Map.get(storage, name, %Medicament{name: name, amount: 0})
    new_medicament = Map.update(existing, :amount, 0, fn c_amount -> c_amount + amount end)
    storage = Map.put(storage, name, new_medicament)
    HomeFirstAidKitStorage.save(storage)
    {:ok, new_medicament}
  end

  @doc """
  Take medicament to First-Aid Kit with decrease amount
  """
  def use_medicament(%{name: name, amount: amount}) do
    storage = HomeFirstAidKitStorage.load()
    value = Map.get(storage, name)
    case value do
       nil -> {:empty, nil}
       existing when is_integer(existing.amount) and existing.amount < amount ->
        {:not_enough, existing}
       existing when is_integer(existing.amount) ->
        medicament_left = Map.update(existing, :amount, 0, fn c_amount -> c_amount - amount end)
        storage = Map.put(storage, name, medicament_left)
        HomeFirstAidKitStorage.save(storage)
        {:ok, medicament_left}
       _ -> {:error, nil}
    end
  end

  @doc """
  Show available medicaments in First-Aid Kit
  """
  def get_available_medicaments() do
    storage = HomeFirstAidKitStorage.load()
    Map.values(storage) |> Enum.filter(fn medicament -> medicament.amount > 0 end)
  end
end
