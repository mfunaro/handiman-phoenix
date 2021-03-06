defmodule Handiman.CourseView do
  use Handiman.Web, :view
  @attributes  ~w(name usga_course_rating slope_rating front_nine back_nine bogey_rating gender course_id)
  def render("tees.json", %{data: data}) do
    if Enum.empty?(data), do: [], else: transform_json(data)
  end

  def transform_json([head | tail], tees \\ []), do: _transform_json([head | tail], tees)
  defp _transform_json([], tees), do: List.flatten(tees)
  defp _transform_json([head | tail], tees), do: _transform_json(tail, [tees, Map.take(head, [:id, :name, :usga_course_rating, :slope_rating, :front_nine, :back_nine, :bogey_rating, :gender])])
end
