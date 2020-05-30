defmodule ResultUtilsTest do
  @moduledoc false
  use ExUnit.Case
  doctest Result.Utils

  # import ExUnit.CaptureIO

  alias Result.Utils

  test "check/1 should raise error if value isn't result" do
    assert_raise Result.TypeError, fn ->
      Utils.check("FOO")
    end
  end
end
