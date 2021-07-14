defmodule ElixirAnalyzer.ExerciseTest.AssertNoCallTest do
  use ElixirAnalyzer.ExerciseTestCase,
    exercise_test_module: ElixirAnalyzer.Support.AnalyzerVerification.AssertNoCall

  test_exercise_analysis "perfect solution",
    comments: [] do
    defmodule AssertNoCallVerification do
      def function() do
        IO.puts("string")
        private_helper()
      end

      def helper do
        :helped
      end

      defp private_helper do
        :privately_helped
      end
    end
  end

  test_exercise_analysis "found a local call to helper function",
    comments: ["found a local call to helper/0"] do
    defmodule AssertNoCallVerification do
      def function() do
        helper() |> IO.puts()
        private_helper()
      end

      def helper do
        :helped
      end

      defp private_helper do
        :privately_helped
      end
    end
  end

  test_exercise_analysis "found a local call to from specific function",
    comments: [
      "found a local call to helper/0",
      "found a local call to private_helper/0 from helper/0"
    ] do
    defmodule AssertNoCallVerification do
      def function() do
        helper() |> IO.puts()
      end

      def helper do
        private_helper()
        :helped
      end

      defp private_helper do
        :privately_helped
      end
    end
  end

  test_exercise_analysis "found a call to other module function anywhere",
    comments: [
      "found a call to Enum.map in solution"
    ] do
    defmodule AssertNoCallVerification do
      def function() do
        Enum.map([], fn x -> x + 1 end)
      end

      def helper do
        :helped
      end

      defp private_helper do
        :privately_helped
      end
    end
  end

  test_exercise_analysis "calling a function with the same name or imported doesn't trigger the check",
    comments: [] do
    [
      defmodule AssertNoCallVerification do
        def function() do
          map([], fn x -> x + 1 end)
        end

        def helper do
          :helped
        end

        defp private_helper do
          :privately_helped
        end
      end,
      defmodule AssertNoCallVerification do
        import Enum

        def function() do
          map([], fn x -> x + 1 end)
        end

        def helper do
          :helped
        end

        defp private_helper do
          :privately_helped
        end
      end
    ]
  end

  test_exercise_analysis "found a call to other module function in specific function",
    comments: [
      "found a call to Atom.to_string/1 in helper/0 function in solution"
    ] do
    defmodule AssertNoCallVerification do
      def function() do
        "something"
      end

      def helper do
        :helped |> Atom.to_string()
      end

      defp private_helper do
        :privately_helped
      end
    end
  end

  test_exercise_analysis "test wildcard",
    comments: [
      "don't call List module functions"
    ] do
    defmodule AssertNoCallVerification do
      def function() do
        "something"
        List.last([])
      end

      def helper do
        :helped
      end

      defp private_helper do
        :privately_helped
      end
    end
  end

  describe "suppress if" do
    @comment "don't call AlternativeList module functions"
    test_exercise_analysis "when suppress condition is false", comments_include: [@comment] do
      defmodule AssertNoCallVerification do
        def function() do
          "something"
          AlternativeList.last([])
        end

        def helper do
          :helped
        end

        defp private_helper do
          :privately_helped
        end
      end
    end

    test_exercise_analysis "when suppress condition is true", comments_exclude: [@comment] do
      defmodule AssertNoCallVerification do
        def function() do
          "something"
          AlternativeList.last([])
          List.last([])
        end

        def helper do
          :helped
        end

        defp private_helper do
          :privately_helped
        end
      end
    end
  end

  test_exercise_analysis "found a call of a :rand function",
    comments: ["found a call to :rand in module functions"] do
    defmodule AssertNoCallVerification do
      def function() do
        IO.puts("string")
        private_helper()
      end

      def helper do
        :helped
      end

      defp private_helper do
        :privately_helped
        :rand.uniform_real()
      end
    end
  end

  test_exercise_analysis "found a call of a :rand function in a specific function",
    comments: [
      "found a call to :rand in module functions in helper/0 function in solution",
      "found a call to :rand in module functions"
    ] do
    defmodule AssertNoCallVerification do
      def function() do
        IO.puts("string")
        private_helper()
      end

      def helper do
        :helped
        :rand.uniform_real()
      end

      defp private_helper do
        :privately_helped
      end
    end
  end

  test_exercise_analysis "found a call of :rand.normal/0",
    comments: [
      "found a call to :rand in module functions",
      "found a call to :rand.normal in solution"
    ] do
    defmodule AssertNoCallVerification do
      def function() do
        IO.puts("string")
        private_helper()
        :rand.normal()
      end

      def helper do
        :helped
      end

      defp private_helper do
        :privately_helped
      end
    end
  end

  test_exercise_analysis "found a call of :rand.normal/0 in specific function",
    comments: [
      "found a call to :rand in module functions",
      "found a call to :rand in module functions in helper/0 function in solution",
      "found a call to :rand.normal in helper/0 function in solution",
      "found a call to :rand.normal in solution"
    ] do
    defmodule AssertNoCallVerification do
      def function() do
        IO.puts("string")
        private_helper()
      end

      def helper do
        :rand.normal()
        :helped
      end

      defp private_helper do
        :privately_helped
      end
    end
  end
end
