defmodule Agoneum.Repo.Migrations.AllowNilUserPassword do
  use Ecto.Migration

  def change do
    alter table(:account_users) do
      modify :password_hash, :string, null: true
    end
  end
end
