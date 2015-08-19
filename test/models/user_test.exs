defmodule Handiman.UserTest do
  use Handiman.ModelCase

  alias Handiman.User

  @valid_attrs %{email: "test@test.com", handicap: 42, name: "some content", encrypted_password: "secret",
                  password: "password", password_confirmation: "password"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
