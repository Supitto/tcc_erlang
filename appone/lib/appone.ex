defmodule Appone do
  use Application

  @impl true
  def start(_type, _args) do

    children = [
      {Task.Supervisor, name: Appone.TaskSupervisor},
      {Task, fn -> Appone.Server.accept(4000) end}
    ]

    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
