defmodule Agoneum.Repo.Migrations.RenameAccountUsersTable do
  use Ecto.Migration

  def change do
    rename table(:account_users), to: table(:users)
  end
end
