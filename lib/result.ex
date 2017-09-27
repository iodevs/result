defmodule Result do
  @moduledoc """
  Documentation for Result.
  """

  defdelegate ok(value), to: Result.Ok, as: :of
  defdelegate error(value), to: Result.Error, as: :of

  defdelegate fold(result), to: Result.Operators
  defdelegate map(result, f), to: Result.Operators
  defdelegate perform(result, f), to: Result.Operators
  defdelegate and_then(result, f), to: Result.Operators
  defdelegate with_default(result, default), to: Result.Operators
  defdelegate resolve(result), to: Result.Operators

  defdelegate error?(result), to: Result.Operators
  defdelegate ok?(result), to: Result.Operators

  defdelegate r_and(r1, r2), to: Result.Calc
  defdelegate r_or(r1, r2), to: Result.Calc
  defdelegate product(list), to: Result.Calc
  defdelegate sum(list), to: Result.Calc
end
