defmodule HomeFirstAidKitTest do
  use ExUnit.Case, async: false
  import Mock
  doctest HomeFirstAidKit

  test_with_mock "no available medicaments", HomeFirstAidKitStorage,
  [load: fn() -> %{} end]
  do
    assert HomeFirstAidKit.get_available_medicaments() == []
  end

  test_with_mock "get available medicaments", HomeFirstAidKitStorage,
  [load: fn() -> %{"Aspirine" => %Medicament{name: "Aspirine", amount: 10}, "Nurofen" => %Medicament{name: "Nurofen", amount: 5}} end]
  do
    assert HomeFirstAidKit.get_available_medicaments() == [%Medicament{name: "Aspirine", amount: 10}, %Medicament{name: "Nurofen", amount: 5}]
  end

  test_with_mock "get available medicaments if amount is 0", HomeFirstAidKitStorage,
  [load: fn() -> %{"Aspirine" => %Medicament{name: "Aspirine", amount: 0}, "Nurofen" => %Medicament{name: "Nurofen", amount: 5}} end]
  do
    assert HomeFirstAidKit.get_available_medicaments() == [%Medicament{name: "Nurofen", amount: 5}]
  end

  test_with_mock "add medicaments to empty storage", HomeFirstAidKitStorage,
  [load: fn() -> %{} end,
  save: fn(_) -> :ok end]
  do
    assert HomeFirstAidKit.add_medicament(%Medicament{name: "Nurofen", amount: 5}) == {:ok, %Medicament{name: "Nurofen", amount: 5}}
  end

  test_with_mock "add medicaments update amount", HomeFirstAidKitStorage,
  [load: fn() -> %{"Aspirine" => %Medicament{name: "Aspirine", amount: 10}, "Nurofen" => %Medicament{name: "Nurofen", amount: 5}} end,
   save: fn(_) -> :ok end]
  do
    assert HomeFirstAidKit.add_medicament(%Medicament{name: "Nurofen", amount: 10}) == {:ok, %Medicament{name: "Nurofen", amount: 15}}
  end

  test_with_mock "use medicament not found", HomeFirstAidKitStorage,
  [load: fn() -> %{"Aspirine" => %Medicament{name: "Aspirine", amount: 10}} end,
   save: fn(_) -> :ok end]
  do
    assert HomeFirstAidKit.use_medicament(%Medicament{name: "Nurofen", amount: 10}) == {:empty, nil}
  end

  test_with_mock "use medicament not enough", HomeFirstAidKitStorage,
  [load: fn() -> %{"Aspirine" => %Medicament{name: "Aspirine", amount: 5}} end,
   save: fn(_) -> :ok end]
  do
    assert HomeFirstAidKit.use_medicament(%Medicament{name: "Aspirine", amount: 10}) == {:not_enough, %Medicament{name: "Aspirine", amount: 5}}
  end

  test_with_mock "use all medicament amount", HomeFirstAidKitStorage,
  [load: fn() -> %{"Aspirine" => %Medicament{name: "Aspirine", amount: 5}} end,
   save: fn(_) -> :ok end]
  do
    assert HomeFirstAidKit.use_medicament(%Medicament{name: "Aspirine", amount: 5}) == {:ok, %Medicament{name: "Aspirine", amount: 0}}
  end

  test_with_mock "use some medicament ok", HomeFirstAidKitStorage,
  [load: fn() -> %{"Aspirine" => %Medicament{name: "Aspirine", amount: 5}} end,
   save: fn(_) -> :ok end]
  do
    assert HomeFirstAidKit.use_medicament(%Medicament{name: "Aspirine", amount: 3}) == {:ok, %Medicament{name: "Aspirine", amount: 2}}
  end

end
