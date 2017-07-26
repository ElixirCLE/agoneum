defmodule Agoneum.Account.User do
  @moduledoc ""
  use Ecto.Schema
  import Ecto.Changeset
  alias Agoneum.Account.User

  @required_fields ~w(email name)a
  @required_reg_fields ~w(password)a ++ @required_fields
  @all_fields ~w(admin)a ++ @required_reg_fields

  schema "users" do
    field :email, :string
    field :name, :string

    field :password, :string, virtual: true
    field :password_hash, :string

    field :admin, :boolean, default: false, null: false

    timestamps()
  end

  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
    |> common_changeset()
  end

  def registration_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, @required_reg_fields)
    |> validate_required(@required_reg_fields)
    |> common_changeset()
  end

  defp common_changeset(changeset) do
    changeset
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password, message: "does not match password")
    |> hash_password
  end

  @spec hash_password(%Ecto.Changeset{}) :: %Ecto.Changeset{}
  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: pass}} = changeset) do
    put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
  end
  defp hash_password(changeset), do: changeset
end
