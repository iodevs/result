defmodule Result do
  @moduledoc """
  Documentation for Result.
  """

  defdelegate map(result, f), to: Result.Operators
end
