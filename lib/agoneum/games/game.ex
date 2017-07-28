defmodule Agoneum.Games.Game do
  @moduledoc ""
  use Ecto.Schema
  import Ecto.Changeset
  alias Agoneum.Games.Game

  @required_fields ~w(name description min_players max_players)a
  @optional_fields ~w(year image)a
  @all_fields @required_fields ++ @optional_fields

  # TODO: Add a unique constraint for name/year combo
  schema "games" do
    field :description, :string
    field :image, :string
    field :max_players, :integer
    field :min_players, :integer
    field :name, :string
    field :year, :integer

    timestamps()
  end

  @doc false
  def changeset(%Game{} = game, attrs) do
    game
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
    |> validate_player_counts
    |> unique_constraint(:name, name: :name_year)
  end

  defp validate_player_counts(changeset) do
    # Pulled this out so that we can access the changes map
    changeset
    |> validate_number(:min_players, greater_than: 0)
    |> validate_number(:min_players,
                       less_than_or_equal_to: Map.get(changeset.changes, :max_players),
                       message: "Min players must be less than or equal to the max players.")
  end
end
