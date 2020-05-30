defmodule Result.Utils do
  @moduledoc """
  A result utility functions
  """

  @spec check(Result.t(a, b)) :: Result.t(a, b) when a: var, b: var
  def check({state, _} = result) when state in [:ok, :error] do
    result
  end

  def check(value) do
    raise Result.TypeError, value
  end
end
