defmodule Result.Error do
  @moduledoc """
  A Error creator
  """

  @doc """
  Create Error result from value

  ## Examples

    iex> Result.Error.of("a")
    {:error, "a"}
    iex> Result.Error.of(12345)
    {:error, 12345}
  """
  def of(value) do
    {:error, value}
  end
end
