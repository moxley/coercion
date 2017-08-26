defmodule CoercionTest do
  use ExUnit.Case, async: true
  import Coercion
  doctest Coercion

  test "coerce :integer" do
    assert coerce("20", :integer) == {:ok, 20}
    assert coerce("", :integer) == {:blank, 0}
    assert coerce("  ", :integer) == {:blank, 0}
    assert coerce("  x", :integer) == {:invalid, 0}
    assert coerce("20.6", :integer) == {:invalid, 20}
    assert coerce(nil, :integer) == {:invalid, 0}
  end

  test "coerce boolean" do
    assert coerce(true, :boolean) == {:ok, true}
    assert coerce(" TRue ", :boolean) == {:ok, true}
    assert coerce(" T ", :boolean) == {:ok, true}
    assert coerce(" Y ", :boolean) == {:ok, true}
    assert coerce(" Yes ", :boolean) == {:ok, true}
    assert coerce(" 1 ", :boolean) == {:ok, true}

    assert coerce(false, :boolean) == {:ok, false}
    assert coerce(" FaLse ", :boolean) == {:ok, false}
    assert coerce(" F ", :boolean) == {:ok, false}
    assert coerce(" N ", :boolean) == {:ok, false}
    assert coerce(" No ", :boolean) == {:ok, false}
    assert coerce(" 0 ", :boolean) == {:ok, false}

    assert coerce(" TRu ", :boolean) == {:invalid, false}
    assert coerce(%{}, :boolean) == {:invalid, false}
  end

  test "coerce string" do
    assert coerce(" hello ", :string) == {:ok, "hello"}
    assert coerce("  ", :string) == {:blank, ""}
    assert coerce(true, :string) == {:ok, "true"}
    assert coerce(false, :string) == {:ok, "false"}
    assert coerce(8, :string) == {:ok, "8"}
    assert coerce(10.5, :string) == {:ok, "10.5"}

    assert coerce(%{}, :string) == {:invalid, ""}
  end

  test "value test" do
    assert value(" hello ", :string) == "hello"
    assert value(" 0 ", :boolean) == false
    assert value(" Y ", :boolean) == true
    assert value("20", :integer) == 20
  end
end
