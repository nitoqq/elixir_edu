defmodule EchoServerTest do
  use ExUnit.Case
  # doctest EchoServer
  setup do
    {:ok, _} = EchoServer.start_link()
    :ok
  end

  test "ping/0" do
    response = EchoServer.ping()
    assert response == {:pong, node()}
  end

  test "ping/1" do
    response = EchoServer.ping(node())
    assert response == {:pong, node()}
  end

end
