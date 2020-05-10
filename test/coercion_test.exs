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

  test "coerce atom" do
    _string_atom = :hello
    _integer_atom = :"11"
    assert coerce("hello", :atom) == {:ok, :hello}
    assert coerce("11", :atom) == {:ok, :"11"}
  end

  test "coerce date" do
    assert coerce("2020-04-02", :date) == {:ok, ~D[2020-04-02]}
    assert coerce("2020-04-", :date) == {:invalid, nil}
    assert coerce(:hello, :date) == {:invalid, nil}
  end

  test "coerce datetime" do
    assert coerce("2020-04-02T12:13:14Z", :datetime) == {:ok, ~U[2020-04-02 12:13:14Z]}
    assert coerce("2020-04-02T12:13:1", :datetime) == {:invalid, nil}
    assert coerce(:hello, :datetime) == {:invalid, nil}
  end

  test "coerce naive_datetime" do
    assert coerce("2020-04-02T12:13:14", :naive_datetime) == {:ok, ~N[2020-04-02 12:13:14]}
    assert coerce("2020-04-02T12:13:1", :naive_datetime) == {:invalid, nil}
    assert coerce(:hello, :naive_datetime) == {:invalid, nil}
  end

  test "value test" do
    assert value(" hello ", :string) == "hello"
    assert value(" 0 ", :boolean) == false
    assert value(" Y ", :boolean) == true
    assert value("20", :integer) == 20
  end
end
