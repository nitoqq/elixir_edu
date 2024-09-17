defmodule HomeFirstAidKitStorage do
  @moduledoc """
  Documentation for `HomeFirstAidKitStorage`.
  """

  @doc """
  Permanent storage for medicaments
  ## Examples
      iex> HomeFirstAidKitStorage.get_storage_path()
      ".data/home_first_aid_kit.json"

  """

  def get_storage_path() do
    Application.get_env(:home_first_aid_kit, :data_dir) <> "/home_first_aid_kit.json"
  end

  def read_json(filename) do
    File.read(filename) |> case do
      {:ok, body} ->
        medicaments = Poison.decode!(body, as: [%Medicament{}])
        {:ok, medicaments}
      {:error, :enoent} -> {:ok,[]}
    end
  end

  def load() do
    {:ok, medicaments} = get_storage_path() |> read_json()
    medicaments |> Map.new(fn medicament -> {medicament.name, medicament} end)
  end

  def save(data) do
    data = Map.values(data) |> Poison.encode!()
    :ok = File.write(get_storage_path(), data)
  end
end
