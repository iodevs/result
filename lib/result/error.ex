defmodule Result.Error do
  @moduledoc """
  A Error creator
  """

  @type t(error) :: {:error, error}

  @doc """
  Create Error result from value

  ## Examples

      iex> Result.Error.of("a")
      {:error, "a"}

      iex> Result.Error.of(12345)
      {:error, 12345}
  """
  @spec of(arg) :: t(arg) when arg: var
  def of(value) do
    {:error, value}
  end
end
