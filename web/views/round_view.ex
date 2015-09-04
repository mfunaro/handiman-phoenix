defmodule Handiman.RoundView do
  use Handiman.Web, :view

  def course_names([head | tail], names \\ []), do: _course_names([head | tail], names)
  defp _course_names([], names), do: List.flatten(names)
  defp _course_names([head | tail], names), do: _course_names(tail, [names, [head["course_name"], head["course_id"]]])
end
