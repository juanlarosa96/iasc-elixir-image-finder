defmodule ImageFinder do
  use Application

  def start(_type, _args) do
    ImageFinder.Supervisor.start_link()
  end

  def fetch(source_file, target_directory) do
    {:ok, pid} = ImageFinder.WorkerDynamicSupervisor.start_child([])
    GenServer.cast(pid, {:fetch, source_file, target_directory})
  end
end

# ImageFinder.fetch "sample.txt", "."
