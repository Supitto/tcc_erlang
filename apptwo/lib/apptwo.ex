defmodule Apptwo do
use Application

  @impl true
  def start(_type, _args) do

    IO.write("Baseline test... ")
    try do
      allowed()
      IO.puts("OK")
    rescue
      _ -> IO.puts("BLOCKED")
    end

    IO.write("Whitelist allowed... ")
    try do
      spawn fn -> whitelist(:no_spw, :"Elixir.Apptwo", :allowed) end
      IO.puts("OK")
    rescue
      _ -> IO.puts("BLOCKED")
    end

    IO.write("Whitelisted yeet... ")
    try do
      spawn fn -> whitelist(:no_spw, :"Elixir.Apptwo", :allowed) end
      IO.puts("OK")
    rescue
      _ -> IO.puts("BLOCKED")
    end


    {:ok, self()}
  end

  def allowed() do
    :ok
  end

  def whitelist(spw, module, func) do
    :erlang.enable_seccomp({:whitelist, spw}, func, module)
    apply(:"Elixir.Apptwo", :allowed, [])
  end
end
