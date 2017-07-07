defmodule Cache do
  use GenServer

  @name CACHE

  ## Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: @name])
  end

  def write(key, value) do
    GenServer.cast(@name, { :write, key, value })
  end

  def read(key) do
    GenServer.call(@name, { :read, key })
  end

  def delete(key) do
    GenServer.cast(@name, { :delete, key })
  end

  def clear do
    GenServer.cast(@name, { :clear })
  end

  def exists?(key) do
    GenServer.call(@name, { :exists?, key })
  end

  ## Server Callbacks

  def init(:ok) do
    { :ok, %{} }
  end

  def handle_call({ :read, key }, _from, cache) do
    value = cache |> Map.get(key)

    { :reply, value, cache }
  end

  def handle_call({ :exists?, key }, _from, cache) do
    has_key? = cache |> Map.has_key?(key)

    { :reply, has_key?, cache }
  end

  def handle_cast({ :write, key, value }, cache) do
    updated_cache  = cache |> Map.put(key, value)

    { :noreply, updated_cache }
  end

  def handle_cast({ :delete, key }, cache) do
    updated_cache  = cache |> Map.delete(key)

    { :noreply, updated_cache }
  end

  def handle_cast({ :clear }, _cache) do
    { :noreply, %{} }
  end
end
