defmodule Result.Calc do
  @moduledoc """
  Result calculations
  """

  @doc """
  Calculate the AND of two results

  r_and :: Result e1 a -> Result e2 b -> Result [e1, e2] [a, b]

  ## Examples

      iex> Result.Calc.r_and({:ok, 1}, {:ok, 2})
      {:ok, [1, 2]}

      iex> Result.Calc.r_and({:ok, 1}, {:error, 2})
      {:error, [2]}

      iex> Result.Calc.r_and({:error, 1}, {:ok, 2})
      {:error, [1]}

      iex> Result.Calc.r_and({:error, 1}, {:error, 2})
      {:error, [1, 2]}

  """
  @spec r_and(Result.t(any, any), Result.t(any, any)) :: Result.t([...], [...])
  def r_and({:ok, val1}, {:ok, val2}) do
    {:ok, [val1, val2]}
  end

  def r_and({:ok, _}, {:error, val2}) do
    {:error, [val2]}
  end

  def r_and({:error, val1}, {:ok, _}) do
    {:error, [val1]}
  end

  def r_and({:error, val1}, {:error, val2}) do
    {:error, [val1, val2]}
  end

  @doc """
  Calculate the OR of two results

  r_or :: Result e1 a -> Result e2 b -> Result [e1, e2] [a, b]

  ## Examples

      iex> Result.Calc.r_or({:ok, 1}, {:ok, 2})
      {:ok, [1, 2]}

      iex> Result.Calc.r_or({:ok, 1}, {:error, 2})
      {:ok, [1]}

      iex> Result.Calc.r_or({:error, 1}, {:ok, 2})
      {:ok, [2]}

      iex> Result.Calc.r_or({:error, 1}, {:error, 2})
      {:error, [1, 2]}

  """
  @spec r_or(Result.t(any, any), Result.t(any, any)) :: Result.t([...], [...])
  def r_or({:ok, val1}, {:ok, val2}) do
    {:ok, [val1, val2]}
  end

  def r_or({:ok, val1}, {:error, _}) do
    {:ok, [val1]}
  end

  def r_or({:error, _}, {:ok, val2}) do
    {:ok, [val2]}
  end

  def r_or({:error, val1}, {:error, val2}) do
    {:error, [val1, val2]}
  end

  @doc """
  Calculate product of Results

  product :: List (Result e a) -> Result (List e) (List a)

  ## Examples

      iex> data = [{:ok, 1}, {:ok, 2}, {:ok, 3}]
      iex> Result.Calc.product(data)
      {:ok, [1, 2, 3]}

      iex> data = [{:error, 1}, {:ok, 2}, {:error, 3}]
      iex> Result.Calc.product(data)
      {:error, [1, 3]}

      iex> data = [{:error, 1}]
      iex> Result.Calc.product(data)
      {:error, [1]}

      iex> data = []
      iex> Result.Calc.product(data)
      {:ok, []}
  """
  @spec product([Result.t(any, any)]) :: Result.t([...], [...])
  def product(list) do
    product(list, {:ok, []})
  end

  defp product([head | tail], acc) do
    result =
      acc
      |> r_and(head)
      |> flatten()

    product(tail, result)
  end

  defp product([], acc) do
    acc
  end

  @doc """
  Calculate sum of Results

  sum :: List (Result e a) -> Result (List e) (List a)

  ## Examples

      iex> data = [{:ok, 1}, {:ok, 2}, {:ok, 3}]
      iex> Result.Calc.sum(data)
      {:ok, [1, 2, 3]}

      iex> data = [{:error, 1}, {:ok, 2}, {:error, 3}]
      iex> Result.Calc.sum(data)
      {:ok, [2]}

      iex> data = [{:error, 1}, {:error, 2}, {:error, 3}]
      iex> Result.Calc.sum(data)
      {:error, [1, 2, 3]}

      iex> data = [{:error, 1}]
      iex> Result.Calc.sum(data)
      {:error, [1]}

      iex> data = []
      iex> Result.Calc.sum(data)
      {:error, []}
  """
  @spec sum([Result.t(any, any)]) :: Result.t([...], [...])
  def sum(list) do
    sum(list, {:error, []})
  end

  defp sum([head | tail], acc) do
    result =
      acc
      |> r_or(head)
      |> flatten

    sum(tail, result)
  end

  defp sum([], acc) do
    acc
  end

  defp flatten({state, [head | tail]}) when is_list(head) do
    {state, head ++ tail}
  end

  defp flatten({state, list}) do
    {state, list}
  end
end
