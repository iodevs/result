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
  @spec and_then(Result.t(any, a), (a -> Result.t(any, any))) :: Result.t(any, any) when a: var
  def and_then({:ok, val}, f) do
    f.(val)
  end

  def and_then({:error, val}, _f) do
    {:error, val}
  end

  @doc """
  Chain together a sequence of computations that may fail for functions with multiple argumets.

  ## Examples

      iex> args = [{:ok, 1}, {:ok, 2}]
      iex> Result.Operators.and_then_x(args, fn (x, y) -> {:ok, x + y} end)
      {:ok, 3}

      iex> args = [{:ok, 1}, {:error, "ERROR"}]
      iex> Result.Operators.and_then_x(args, fn (x, y) -> {:ok, x + y} end)
      {:error, "ERROR"}

  """
  @spec and_then_x([Result.t(any(), any())], (... -> Result.t(any(), any()))) :: Result.t(any(), any())
  def and_then_x(args, f) do
    args
    |> fold()
    |> and_then(&apply(f, &1))
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
  @spec fold([Result.t(any, any)]) :: Result.t(any, [any])
  def fold(list) do
    fold(list, [])
  end

  defp fold([{:ok, v} | tail], acc) do
    fold(tail, [v | acc])
  end

  defp fold([{:error, v} | _tail], _acc) do
    {:error, v}
  end

  defp fold([], acc) do
    {:ok, Enum.reverse(acc)}
  end

  @doc """
  Apply a function `f` to `value` if result is Ok.

  ## Examples

      iex> ok = {:ok, 3}
      iex> Result.Operators.map(ok, fn(x) -> x + 10 end)
      {:ok, 13}

      iex> error = {:error, 3}
      iex> Result.Operators.map(error, fn(x) -> x + 10 end)
      {:error, 3}

  """
  @spec map(Result.t(any, a), (a -> b)) :: Result.t(any, b) when a: var, b: var
  def map({:ok, value}, f) when is_function(f, 1) do
    {:ok, f.(value)}
  end

  def map({:error, _} = result, _f), do: result

  @doc """
  Apply a function if both results are Ok. If not, the first Err will propagate through.

  ## Examples

      iex> Result.Operators.map2({:ok, 1}, {:ok, 2}, fn(x, y) -> x + y end)
      {:ok, 3}

      iex> Result.Operators.map2({:ok, 1}, {:error, 2}, fn(x, y) -> x + y end)
      {:error, 2}

      iex> Result.Operators.map2({:error, 1}, {:error, 2}, fn(x, y) -> x + y end)
      {:error, 1}

  """
  @spec map2(Result.t(any, a), Result.t(any, b), (a, b -> c)) :: Result.t(any, c)
        when a: var, b: var, c: var
  def map2({:ok, val1}, {:ok, val2}, f) when is_function(f, 2) do
    {:ok, f.(val1, val2)}
  end

  def map2({:error, _} = result, _, _f), do: result
  def map2(_, {:error, _} = result, _f), do: result

  @doc """
  Perform function `f` on Ok result and return it

  ## Examples

      iex> Result.Operators.perform({:ok, 123}, fn(x) -> x * 100 end)
      {:ok, 123}

      iex> Result.Operators.perform({:error, 123}, fn(x) -> IO.puts(x) end)
      {:error, 123}

  """
  @spec perform(Result.t(err, val), (val -> any)) :: Result.t(err, val) when err: var, val: var
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
  @spec with_default(Result.t(any, val), val) :: val when val: var
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
  @spec error?(Result.t(any, any)) :: boolean
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
  @spec ok?(Result.t(any, any)) :: boolean
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
  @spec resolve(Result.t(any, Result.t(any, any))) :: Result.t(any, any)
  def resolve({:ok, {state, _value} = result}) when state in [:ok, :error] do
    result
  end

  def resolve({:error, _value} = result) do
    result
  end

  @doc """
  Retry `count` times the function `f` if the result is negative

  retry :: Result err a -> (a -> Result err b) -> Int -> Int -> Result err b

  * `res` - input result
  * `f` - function retruns result
  * `count` - try count
  * `timeout` - timeout between retries

  ## Examples

      iex> Result.Operators.retry({:error, "Error"}, fn(x) -> {:ok, x} end, 3)
      {:error, "Error"}

      iex> Result.Operators.retry({:ok, "Ok"}, fn(x) -> {:ok, x} end, 3)
      {:ok, "Ok"}

      iex> Result.Operators.retry({:ok, "Ok"}, fn(_) -> {:error, "Error"} end, 3, 0)
      {:error, "Error"}
  """
  @spec retry(Result.t(any, val), (val -> Result.t(any, any)), integer, integer) ::
          Result.t(any, any)
        when val: var
  def retry(res, f, count, timeout \\ 1000)

  def retry({:ok, value}, f, count, timeout) do
    value
    |> f.()
    |> again(value, f, count, timeout)
  end

  def retry({:error, _} = error, _f, _count, _timeout) do
    error
  end

  defp again({:error, _} = error, _value, _f, 0, _timeout) do
    error
  end

  defp again({:error, _}, value, f, count, timeout) do
    Process.sleep(timeout)
    again(f.(value), value, f, count - 1, timeout)
  end

  defp again(res, _value, _f, _count, _timeout) do
    res
  end
end
