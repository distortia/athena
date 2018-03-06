# Athena

[![pipeline status](https://gitlab.com/distortia/athena/badges/master/pipeline.svg)](https://gitlab.com/distortia/athena/commits/master)

An ANSI to HTML converter. Built for the usage of Cucumber output.

## Installation

```elixir
def deps do
  [
    {:athena, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc).

The docs can be found at [https://hexdocs.pm/athena](https://hexdocs.pm/athena).


## Examples

Basic usage: 

```elixir
iex> Athena.ansi_to_html("\e[4mfoo\e[0m")
"<span style='text-decoration: underline;'>foo</span>"
```

To see the list of support `ansi_codes`:

```elixir
iex> Athena.ansi_codes()
%{
  "0m" => "</span>",
  "1m" => "<span style='font-weight: bold;'>",
  "4m" => "<span style='text-decoration: underline;'>",
  "30m" => "<span style='color: black;'>",
  "31m" => "<span style='color: red;'>",
  ...
}
```

## Contributing

Issues and PRs are welcome. If you are to make a PR, please use the `mix format` command before committing.

