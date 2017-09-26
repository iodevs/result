defmodule Result.Operators do
  @moduledoc """
  A result operators.
  """

  @doc """
  Chain together a sequence of computations that may fail.

  ## Examples

      iex> val = {:ok, 1}
      iex> Result.Operators.and_then(val, fn (x) -> {:ok, x + 1} end)
      {:ok, 2}

      iex> val = {:error, 1}
      iex> Result.Operators.and_then(val, fn (x) -> {:ok, x + 1} end)
      {:error, 1}

  """
  def and_then({:ok, val}, f) do
    f.(val)
  end

  def and_then({:error, val}, _f) do
    {:error, val}
  end

  @doc """
  Fold function returns tuple `{:ok, [...]}` if all
  tuples in list contain `:ok` or `{:error, ...}` if
  only one tuple contains `:error`.

  ## Examples

      iex> val = [{:ok, 3}, {:ok, 5}, {:ok, 12}]
      iex> Result.Operators.fold(val)
      {:ok, [3, 5, 12]}

      iex> val = [{:ok, 3}, {:error, 1}, {:ok, 2}, {:error, 2}]
      iex> Result.Operators.fold(val)
      {:error, 1}

  """
  def fold(list, acc \\ [])
  def fold([{:ok, v} | tail], acc) do
    fold(tail, [v | acc])
  end

  def fold([{:error, v} | _tail], _acc)  do
    {:error, v}
  end

  def fold([], acc) do
    {:ok, Enum.reverse(acc)}
  end

  @doc """
  Map function `f` to `value` stored in Ok result

  ## Examples

      iex> ok = {:ok, 3}
      iex> Result.Operators.map(ok, fn(x) -> x + 10 end)
      {:ok, 13}

      iex> error = {:error, 3}
      iex> Result.Operators.map(error, fn(x) -> x + 10 end)
      {:error, 3}

  """
  def map({:ok, value}, f) do
    {:ok, f.(value)}
  end

  def map({:error, _} = result, _f), do: result

  @doc """
  Perform function `f` on Ok result and return it

  ## Examples

      iex> Result.Operators.perform({:ok, 123}, fn(x) -> x * 100 end)
      {:ok, 123}

      iex> Result.Operators.perform({:error, 123}, fn(x) -> IO.puts(x) end)
      {:error, 123}

  """
  def perform({:ok, value} = result, f) do
    f.(value)
    result
  end
  def perform({:error, _} = result, _f), do: result

  @doc """
  Return `value` if result is ok, otherwise `default`

  ## Examples

      iex> Result.Operators.with_default({:ok, 123}, 456)
      123

      iex> Result.Operators.with_default({:error, 123}, 456)
      456

  """
  def with_default({:ok, value}, _default), do: value
  def with_default({:error, _}, default), do: default

  @doc """
  Return `true` if result is error

  ## Examples

      iex> Result.Operators.error?({:error, 123})
      true

      iex> Result.Operators.error?({:ok, 123})
      false

  """
  def error?({:error, _}), do: true
  def error?(_result), do: false

  @doc """
  Return `true` if result is ok

  ## Examples

      iex> Result.Operators.ok?({:ok, 123})
      true

      iex> Result.Operators.ok?({:error, 123})
      false

  """
  def ok?({:ok, _}), do: true
  def ok?(_result), do: false


  @doc """
  Flatten nested results

  resolve :: Result x (Result x a) -> Result x a

  ## Examples

      iex> Result.Operators.resolve({:ok, {:ok, 1}})
      {:ok, 1}

      iex> Result.Operators.resolve({:ok, {:error, "one"}})
      {:error, "one"}

      iex> Result.Operators.resolve({:error, "two"})
      {:error, "two"}
  """
  def resolve({:ok, {state, _value} = result}) when state in [:ok, :error] do
    result
  end

  def resolve({:error, _value} = result) do
    result
  end
end
