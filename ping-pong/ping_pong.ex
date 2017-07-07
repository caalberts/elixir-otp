defmodule PingPong do

  def start do
    a = spawn(__MODULE__, :respond, [])
    b = spawn(__MODULE__, :respond, [])

    send a, {:ping, b}

    IO.puts("Parent's PID: #{inspect self()}")
  end

  def respond do
    receive do
      {message, origin} ->
        reply = case message do
          :ping -> :pong
          :pong -> :ping
        end
        IO.puts "PID: #{inspect self()} - received #{message}, sending: #{reply}"

        :timer.sleep(1000)
        send origin, {reply, self()}
    end

    respond()
  end

end
