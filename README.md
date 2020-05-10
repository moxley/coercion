# Coercion

Coerce dirty values to clean Elixir primitive types, with validation.

[![Build Status](https://api.travis-ci.org/moxley/coercion.svg?branch=master)](https://travis-ci.org/moxley/coercion)

```elixir
import Coercion

{:ok, 20} = coerce(" 20 ", :integer)
{:invalid, 0} = coerce("  x", :integer)

{:ok, true} = coerce(" TRue ", :boolean)
{:ok, true} = coerce(" T ", :boolean)
{:ok, true} = coerce(" Y ", :boolean)
{:ok, true} = coerce(" Yes ", :boolean)
{:ok, true} = coerce(" 1 ", :boolean)
{:invalid, false} = coerce(" TRu ", :boolean)
{:ok, false} = coerce(" F ", :boolean)
{:ok, false} = coerce(" N ", :boolean)
{:ok, false} = coerce(" 0 ", :boolean)

{:ok, "hello"} = coerce(" hello ", :string)
{:blank, ""} = coerce("  ", :string)
{:ok, "true"} = coerce(true, :string)
{:ok, "10.5"} = coerce(10.5, :string)

{:ok, ~D[2020-04-02]} = coerce("2020-04-02", :date)
{:ok, ~U[2020-04-02 12:00:01Z]} = coerce("2020-04-02T12:00:01Z", :datetime)
{:ok, ~N[2020-04-02 12:00:01]} = coerce("2020-04-02T12:00:01Z", :naive_datetime)
```

The primary use case is decoding values that come from external sources where
everything is just a String.

Example sources:

- URL-encoded values
  ```
  name=Kate&age=40&subscribed=Y
  ```
- CSV
  ```csv
  name,age,subscribed
  Kate,40,T
  ```
- XML
  ```xml
  <row>
    <name>Kate</name>
    <age>40</age>
    <subscribed>Yes</subscribed>
  </row>
  ```

[`Ecto.Schema`](https://hexdocs.pm/ecto/Ecto.Schema.html) is often a good
fit for this type of problem, but sometimes it's overkill.

## Installation

The package can be installed
by adding `coercion` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:coercion, "~> 1.0.0"}]
end
```

Then, run `mix deps.get`, and you're ready to go.

API Documentation: [https://hexdocs.pm/coercion](https://hexdocs.pm/coercion).

License: https://github.com/moxley/coercion/blob/master/LICENSE
