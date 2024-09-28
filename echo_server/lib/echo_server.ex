defmodule EchoServer do
  @moduledoc """
  Documentation for `EchoServer`.
  """

  @doc """
  Echo server

  ## Examples

      iex> EchoServer.ping(node())
      {:pong, :nonode@nohost}

  """

  def wait_ping() do
    receive do
      {:ping, client} ->
        send(client, {:pong, node()})
      after 1000 ->
        :timeoout
    end
  end

  defp wait_pong() do
    receive do
      {:pong, remote_node} ->
        {:pong, remote_node}
      after 1000 ->
        {:timeoout, 1000}
    end
  end

  def ping(node) do
    pid = Node.spawn_link(node, EchoServer, :wait_ping, [])
    send(pid, {:ping, self()})
    wait_pong()
  end

end
