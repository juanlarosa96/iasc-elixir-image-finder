defmodule ImageFinder.Downloader do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def child_spec(state) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [state]},
      type: :worker,
      restart: :transient
    }
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def handle_cast({:fetch, link, target_directory}, _state) do
    IO.puts("Going to download #{link} to #{target_directory}")

    fetch_link(link, target_directory)
    {:stop, :normal, []}
  end

  def fetch_link(link, target_directory) do
    HTTPotion.get(link).body |> save(target_directory)
  end

  def digest(body) do
    :crypto.hash(:md5, body) |> Base.encode16()
  end

  def save(body, directory) do
    File.write!("#{directory}/#{digest(body)}", body)
  end

  def terminate(reason, state) do
    IO.puts("Ended with reason #{reason}")
  end
end
