defmodule Oauthenator.UserTest do
  use ExUnit.Case
  use Timex
  alias Oauthenator.User

  @valid_attrs %{email: "test@example.com", password: "12345"}
  @invalid_attrs %{}

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(Oauthenator.Repo)
  end

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

end
