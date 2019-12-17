  defmodule Appone.Server do
    require Logger

    def secret do
      "secret string"
      Logger.info("Got here")
    end

    def accept(port) do
      Logger.info("Started app")
      {:ok, socket} =
        :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])

      Logger.info("Accepting connection on port #{port}")
      loop_acceptor(socket)
    end

    defp loop_acceptor(socket) do
      {:ok, client} = :gen_tcp.accept(socket)
      {:ok, pid} = Task.Supervisor.start_child(Appone.TaskSupervisor, fn -> serve(client) end)
      :ok = :gen_tcp.controlling_process(client, pid)
      loop_acceptor(socket)
    end

    defp serve(socket) do
      :erlang.enable_seccomp({:blacklist, :no_spawn}, :secret, :"Elixir.Appone.Server")


      {:ok, quoted} =
        socket
        |> read_line()
        |> Code.string_to_quoted()

      Logger.info("Recived #{inspect quoted}")
      {code, []} = Code.eval_quoted(quoted)

      code
      |> Code.eval_quoted()
      |> inspect
      |> Kernel.<>("\n")
      |> write_line(socket)
    end

    defp read_line(socket) do
      {:ok, data} = :gen_tcp.recv(socket, 0)
      data
    end

    defp write_line(line, socket) do
      :gen_tcp.send(socket, line)
    end
  end
