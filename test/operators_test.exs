defmodule ResultOperatorTest do
  use ExUnit.Case
  doctest Result.Operators

  import ExUnit.CaptureIO

  alias Result.Operators

  describe "Perform" do
    test "run function if result is ok" do
      fun = fn ->
        assert Operators.perform({:ok, 123}, fn(x) -> IO.puts(x) end) == {:ok, 123}
      end

      assert capture_io(fun) == "123\n"
    end

    test "don\'t run function if result is error" do
      fun = fn ->
        assert Operators.perform({:error, 123}, fn(x) -> IO.puts(x) end) == {:error, 123}
      end

      assert capture_io(fun) == ""
    end
  end
end

