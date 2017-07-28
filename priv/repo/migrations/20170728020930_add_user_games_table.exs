defmodule Agoneum.Repo.Migrations.AddUserGamesTable do
  use Ecto.Migration

  def change do
    create table(:user_games, primary_key: false) do
      add :user_id, references(:users)
      add :game_id, references(:games)
    end
  end
end
