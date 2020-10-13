defmodule ImageFinder.Supervisor do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(args) do
    # IO.puts("init supervisor")
    # IO.inspect("Los args son #{args}")
    children = [
      ImageFinder.Worker,
      ImageFinder.DownloaderDynamicSupervisor,
      ImageFinder.Parser
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
