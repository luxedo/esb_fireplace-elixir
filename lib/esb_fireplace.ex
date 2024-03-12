defmodule EsbFireplace do
  @moduledoc """
  Documentation for `EsbFireplace`.

  The FIREPLACEv1.0 allows the use of the `esb` tooling for solving Advent of Code problems.
  This is an implementation of FIREPLACEv1.0 for elixir.

  Check [esb](https://github.com/luxedo/esb) for more information.
  """
  @help_usage "usage: Elf Script Brigade elixir solution runner [-h] -p {1,2} [-a [ARGS ...]]"
  @help_missing_part_argument "error: the following arguments are required: -p/--part"
  @help_options """
  options:
   -h, --help            show this help message and exit
   -p {1,2}, --part {1,2}
                         Run solution part 1 or part 2
   -a [ARGS ...], --args [ARGS ...]
                         Additional arguments for running the solutions
  """
  @help "#{@help_usage}\n#{@help_options}"

  defp help_part_error(part) do
    "error: argument -p/--part: invalid choice: #{part} (choose from 1, 2)"
  end

  defp run_solution(solve_pt1, solve_pt2, part, args, io)
       when is_function(solve_pt1) and is_function(solve_pt2) do
    stdin = io.read(:eof)

    case part do
      1 -> solve_pt1.(stdin, args)
      2 -> solve_pt2.(stdin, args)
    end
  end

  defp v1_run(args, solve_pt1, solve_pt2, :no_halt, io \\ IO)
       when is_list(args) and is_function(solve_pt1) and is_function(solve_pt2) do
    {options, err} =
      OptionParser.parse!(args,
        strict: [part: :integer, args: :string, help: :boolean],
        aliases: [h: :help, p: :part, a: :args]
      )

    # @TODO: passing err to :args is wrong. Check this correctly
    options =
      Keyword.update(options, :args, [], &[&1 | err])
      |> Enum.into(%{})

    case options do
      %{help: true} ->
        {:err, @help}

      %{args: args, part: part} when part in [1, 2] ->
        {dt, ans} = :timer.tc(&run_solution/5, [solve_pt1, solve_pt2, part, args, io])
        message = "#{ans}\nRT #{dt} microseconds"
        {:ok, message}

      %{part: part} ->
        message = "#{@help_usage}\n#{help_part_error(part)}"
        {:err, message}

      %{args: _} ->
        message = "#{@help_usage}\n#{@help_missing_part_argument}"
        {:err, message}
    end
  end

  ##############################################################################################
  # Public API
  ##############################################################################################
  @doc """
  Runs solutions given command line arguments and stdin.
  """
  @spec v1_run(fun(), fun()) :: :ok | :err
  def v1_run(solve_pt1, solve_pt2) when is_function(solve_pt1) and is_function(solve_pt2) do
    v1_run(System.argv(), solve_pt1, solve_pt2)
  end

  @spec v1_run(list, fun(), fun()) :: :ok | :err
  def v1_run(args, solve_pt1, solve_pt2)
      when is_list(args) and is_function(solve_pt1) and is_function(solve_pt2) do
    case v1_run(args, solve_pt1, solve_pt2, :no_halt) do
      {:err, message} ->
        IO.puts(message)
        System.halt(1)
        :err

      {:ok, message} ->
        IO.puts(message)
        :ok
    end
  end

  if Mix.env() == :test do
    def v1_test_run(args, solve_pt1, solve_pt2, mock_io)
        when is_list(args) and is_function(solve_pt1) and is_function(solve_pt2) do
      v1_run(args, solve_pt1, solve_pt2, :no_halt, mock_io)
    end
  end
end
