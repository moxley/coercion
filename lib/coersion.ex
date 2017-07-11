defmodule Coercion do
  @moduledoc """
  Rigorous coercion of untrusted values to native primitive types
  """

  @spec coerce(any, :integer | :boolean | :string) :: {:ok | :invalid | :blank, String.t | integer | Boolean.t }

  @doc """
  Coerce and validate a value to the given type.

  ## Examples

      iex> import Coercion # For demo purposes
      Coercion

      iex> coerce(" 20 ", :integer)
      {:ok, 20}
      iex> coerce("  x", :integer)
      {:invalid, 0}

      iex> coerce(" TRue ", :boolean)
      {:ok, true}
      iex> coerce(" T ", :boolean)
      {:ok, true}
      iex> coerce(" y ", :boolean)
      {:ok, true}
      iex> coerce(" Yes ", :boolean)
      {:ok, true}
      iex> coerce(" 1 ", :boolean)
      {:ok, true}
      iex> coerce(" TRu ", :boolean)
      {:invalid, false}
      iex> coerce(" F ", :boolean)
      {:ok, false}
      iex> coerce(" N ", :boolean)
      {:ok, false}
      iex> coerce(" 0 ", :boolean)
      {:ok, false}

      iex> coerce(" hello ", :string)
      {:ok, "hello"}
      iex> coerce("  ", :string)
      {:blank, ""}
      iex> coerce(true, :string)
      {:ok, "true"}
      iex> coerce(10.5, :string)
      {:ok, "10.5"}

  """

  # Integer
  def coerce(value, :integer) when is_integer(value), do: {:ok, value}
  def coerce(value, :integer) when is_float(value), do: {:ok, Kernel.round(value)}
  def coerce(value, :integer) when is_bitstring(value) do
    value
    |> String.trim
    |> coerce(:integer, :trimmed)
  end
  def coerce(_value, :integer), do: {:invalid, 0}

  # Boolean
  def coerce(value, :boolean) when is_boolean(value), do: {:ok, value}
  def coerce(value, :boolean) when is_bitstring(value) do
    value
    |> String.trim
    |> coerce(:boolean, :trimmed)
  end
  def coerce(_value, :boolean), do: {:invalid, false}

  # String
  def coerce(value, :string) when is_integer(value), do: coerce(Integer.to_string(value), :string)
  def coerce(value, :string) when is_float(value), do: coerce(Float.to_string(value), :string)
  def coerce(_value = true, :string), do: coerce("true", :string)
  def coerce(_value = false, :string), do: coerce("false", :string)
  def coerce(value, :string) when is_nil(value), do: coerce("", :string)
  def coerce(value, :string) when is_bitstring(value) do
    value
    |> String.trim
    |> coerce(:string, :trimmed)
  end
  def coerce(_value, :string), do: {:invalid, ""}

  #
  # Private functions
  #

  # Integer from a trimmed string
  defp coerce(_value = "", :integer, :trimmed), do: {:blank, 0}
  defp coerce(value, :integer, :trimmed) do
    Integer.parse(value, 10)
    |> coerce(:integer, :parsed)
  end

  # From the result of `Integer.parse`
  defp coerce(:error, :integer, :parsed), do: {:invalid, 0}
  defp coerce({int, ""}, :integer, :parsed), do: {:ok, int}
  defp coerce({int, _}, :integer, :parsed), do: {:invalid, int}

  # From a trimmed string
  defp coerce(_value = "", :string, :trimmed), do: {:blank, ""}
  defp coerce(value, :string, :trimmed), do: {:ok, value}

  # Parse boolean from trimmed string
  defp coerce(value, :boolean, :trimmed), do: coerce(String.downcase(value), :boolean, :downcased)
  # Parse boolean from trimmed, downcased string
  defp coerce(_value = "true", :boolean, :downcased), do: {:ok, true}
  defp coerce(_value = "false", :boolean, :downcased), do: {:ok, false}
  defp coerce(_value = "t", :boolean, :downcased), do: {:ok, true}
  defp coerce(_value = "f", :boolean, :downcased), do: {:ok, false}
  defp coerce(_value = "yes", :boolean, :downcased), do: {:ok, true}
  defp coerce(_value = "no", :boolean, :downcased), do: {:ok, false}
  defp coerce(_value = "y", :boolean, :downcased), do: {:ok, true}
  defp coerce(_value = "n", :boolean, :downcased), do: {:ok, false}
  defp coerce(_value = "on", :boolean, :downcased), do: {:ok, true}
  defp coerce(_value = "off", :boolean, :downcased), do: {:ok, false}
  defp coerce(_value = "1", :boolean, :downcased), do: {:ok, true}
  defp coerce(_value = "0", :boolean, :downcased), do: {:ok, false}
  defp coerce(_value = "", :boolean, :downcased), do: {:blank, false}
  defp coerce(_value, :boolean, :downcased), do: {:invalid, false}
end
