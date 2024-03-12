defmodule EsbFireplaceTest do
  use ExUnit.Case

  @esb_command_header "Elf Script Brigade elixir solution runner"
  @pt2_solution 2

  def solve_pt1(input_data, args) do
    if length(args) > 0 do
      Enum.join(args, " ")
    else
      String.trim(input_data)
    end
  end

  def solve_pt2(_input_data, _args) do
    @pt2_solution
  end

  defmodule MockIO do
    @test_input "Any input\n"
    def read(_device \\ :stdio, _line_or_chars \\ :eof), do: @test_input
  end

  defp run(args) do
    EsbFireplace.v1_test_run(
      args,
      &EsbFireplaceTest.solve_pt1/2,
      &EsbFireplaceTest.solve_pt2/2,
      MockIO
    )
  end

  ##############################################################################################
  # Tests
  ##############################################################################################
  test "Prints help information with --help flag" do
    {status, message} = run(["--help"])
    assert status == :err
    assert String.contains?(message, @esb_command_header)
  end

  test "Fails when passing no arguments" do
    {status, message} = run([])
    assert status == :err
    assert String.contains?(message, "error: the following arguments are required")
  end

  test "Fails when passing --part 0" do
    {status, message} = run(["--part", "0"])
    assert status == :err
    assert String.contains?(message, "error: argument -p/--part: invalid choice: 0")
  end

  test "Run must print the solution in the first line" do
    {status, message} = run(["--part", "1"])
    assert status == :ok
    [ans, _] = String.replace_suffix(message, "\n", "") |> String.split("\n")
    assert ans == MockIO.read() |> String.trim()
  end

  test "Run must print the running time the second line" do
    {status, message} = run(["--part", "1"])
    assert status == :ok
    [_, time] = String.replace_suffix(message, "\n", "") |> String.split("\n")
    assert Regex.match?(~r/RT \d+ microseconds/, time)
  end

  test "Run must return only two lines" do
    {status, message} = run(["--part", "1"])
    assert status == :ok
    lines = String.replace_suffix(message, "\n", "") |> String.split("\n")
    assert length(lines) == 2
  end

  test "Run must run solution_pt2" do
    {status, message} = run(["--part", "2"])
    assert status == :ok
    [ans, _] = String.replace_suffix(message, "\n", "") |> String.split("\n")
    assert ans == Integer.to_string(@pt2_solution)
  end

  test "Run must accept shorthand part argument" do
    {status, message} = run(["--part", "2"])
    assert status == :ok
    [ans, _] = String.replace_suffix(message, "\n", "") |> String.split("\n")
    assert ans == Integer.to_string(@pt2_solution)
  end

  test "Run must accept optional positional arguments" do
    args = ["a", "b", "c"]
    {status, message} = run(["--part", "1", "--args" | args])
    assert status == :ok
    [ans, _] = String.replace_suffix(message, "\n", "") |> String.split("\n")
    assert ans == Enum.join(args, " ")
  end
end
