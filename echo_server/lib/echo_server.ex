defmodule EchoServer do
  use GenServer

  @moduledoc """
  Documentation for `EchoServer`.
  """
  # Client

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def ping() do
    GenServer.call(__MODULE__, {:ping})
  end

  def ping(remote_node) do
    GenServer.call({__MODULE__, remote_node}, {:ping})
  end

  def stop do
    GenServer.stop(__MODULE__)
  end

  # Server (callbacks)

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:ping}, _from, state) do
    {:reply, {:pong, node()}, state}
  end
end
