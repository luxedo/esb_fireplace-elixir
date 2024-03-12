# EsbFireplace - Elixir

The FIREPLACEv1.0 allows the use of the `esb` tooling for solving Advent of Code problems.
This is an implementation of FIREPLACEv1.0 for [elixir](https://elixir-lang.org/).

Check [esb](https://github.com/luxedo/esb) for more information.

## Installation

The package can be installed by adding `esb_fireplace` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:esb_fireplace, "~> 0.1.0"}
  ]
end
```

## Usage

Create a function named `start` in your solution file and add `EsbFireplace.v1_run` to it.

```elixir
defmodule Year2023Day01 do
  import EsbFireplace

  def solve_pt1(input_data, _args) do
    # Solve pt1
    :hello
  end

  def solve_pt2(input_data, _args) do
    # Solve pt2
    :world
  end

  def start do
    # 🎅🎄❄️☃️🎁🦌
    # Bright christmas lights HERE
    v1_run(&solve_pt1/2, &solve_pt2/2)
  end
end
```

Running can be done with `mix`, but this library is meant to be used with [esb](https://github.com/luxedo/esb).

```bash
# You can do this...
mix run -e Year2023Day01.start -- --part 1 < input_data.txt

# But instead do this:
esb run --year 2023 --day 1 --part 1
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/esb_fireplace>.

## License

> ESB - Script your way to rescue Christmas as part of the ElfScript Brigade team.
> Copyright (C) 2024 Luiz Eduardo Amaral <luizamaral306@gmail.com>
>
> This program is free software: you can redistribute it and/or modify
> it under the terms of the GNU General Public License as published by
> the Free Software Foundation, either version 3 of the License, or
> (at your option) any later version.
> This program is distributed in the hope that it will be useful,
> but WITHOUT ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> GNU General Public License for more details.
> You should have received a copy of the GNU General Public License
> along with this program. If not, see <http://www.gnu.org/licenses/>.
