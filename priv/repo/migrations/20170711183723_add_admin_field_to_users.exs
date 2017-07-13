defmodule Agoneum.Repo.Migrations.AddAdminGuestActiveFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:account_users) do
      add :admin, :boolean, default: false, null: false
    end
  end
end
