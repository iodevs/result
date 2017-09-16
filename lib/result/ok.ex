defmodule Result.Ok do
  @moduledoc """
  A Ok creator
  """

  @doc """
  Create Ok result from value

  ## Examples

      iex> Result.Ok.of("a")
      {:ok, "a"}

      iex> Result.Ok.of(12345)
      {:ok, 12345}

  """
  def of(value) do
    {:ok, value}
  end
end
