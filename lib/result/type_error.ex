defmodule Result.TypeError do
  defexception [:message]

  @impl true
  def exception(value) do
    msg = "is not in {:ok, value} or {:error, error} format, instead got: #{inspect(value)}"
    %__MODULE__{message: msg}
  end
end
