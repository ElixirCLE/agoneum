defmodule Agoneum.Account.User do
  @moduledoc ""
  use Ecto.Schema
  import Ecto.Changeset
  alias Agoneum.Account.User

  @required_fields ~w(email name)a
  @optional_fields ~w(active admin password)a
  @all_fields @required_fields ++ @optional_fields

  @required_reg_fields ~w(password)a ++ @required_fields
  @all_reg_fields @required_reg_fields ++ @optional_fields

  schema "account_users" do
    field :email, :string
    field :name, :string

    field :password, :string, virtual: true
    field :password_hash, :string

    field :active, :boolean, default: false
    field :admin, :boolean, default: false

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
    |> cast(attrs, @all_reg_fields)
    |> validate_required(@required_reg_fields)
    |> common_changeset()
  end

  defp common_changeset(changeset) do
    changeset
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password, message: "does not match password")
    |> hash_password
  end

  def display_name(user) do
    display_name(user.email, user.name)
  end
  defp display_name(_, name) when not is_nil(name) do
    name
  end
  defp display_name(email, _) do
    email
  end

  @spec hash_password(%Ecto.Changeset{}) :: %Ecto.Changeset{}
  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: pass}} = changeset) do
    put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
  end
  defp hash_password(changeset), do: changeset
end
