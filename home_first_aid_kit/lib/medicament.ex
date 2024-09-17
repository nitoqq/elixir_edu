defmodule Medicament do
  @derive [Poison.Encoder]
  defstruct [:name, :amount]
end
