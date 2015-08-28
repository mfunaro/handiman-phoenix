defmodule Handiman.TeeTest do
  use Handiman.ModelCase

  alias Handiman.Tee

  @valid_attrs %{back_nine: "some content", bogey_rating: "120.5", front_nine: "some content", gender: "some content", name: "some content", slope_rating: 42, usga_course_rating: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Tee.changeset(%Tee{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Tee.changeset(%Tee{}, @invalid_attrs)
    refute changeset.valid?
  end
end
