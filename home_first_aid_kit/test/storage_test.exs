defmodule HomeFirstAidKitStorageTest do
  use ExUnit.Case, async: false
  import Mock
  doctest HomeFirstAidKitStorage

  test_with_mock "no available medicaments", File,
  [read: fn(_) -> {:ok, "[]"} end]
  do
    assert HomeFirstAidKitStorage.load() == %{}
  end

  test_with_mock "storage file does not exist", File,
  [read: fn(_) -> {:error, :enoent} end]
  do
    assert HomeFirstAidKitStorage.load() == %{}
  end

  test_with_mock "storage load ok", File,
  [read: fn(_) -> {:ok, "[{\"name\":\"Aspirine\", \"amount\": 10}, {\"name\":\"Paracetamol\", \"amount\": 5}]"} end]
  do
    assert HomeFirstAidKitStorage.load() == %{
      "Aspirine" => %Medicament{name: "Aspirine", amount: 10},
      "Paracetamol" => %Medicament{name: "Paracetamol", amount: 5}
    }
  end

  test_with_mock "storage save ok", File,
  [write: fn(_path, _data) -> :ok end]
  do
    HomeFirstAidKitStorage.save(%{
      "Aspirine" => %Medicament{name: "Aspirine", amount: 10},
      "Paracetamol" => %Medicament{name: "Paracetamol", amount: 5}
    })
    assert_called_exactly File.write(:_, "[{\"amount\":10,\"name\":\"Aspirine\"},{\"amount\":5,\"name\":\"Paracetamol\"}]"), 1
  end

end
