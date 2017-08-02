defmodule Agoneum.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :name, :string
      add :year, :integer
      add :description, :string
      add :min_players, :integer
      add :max_players, :integer
      add :image, :string

      timestamps()
    end

    create unique_index(:games, [:name, :year], name: :name_year)
  end
end
