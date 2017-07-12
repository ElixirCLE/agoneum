defmodule Agoneum.Repo.Migrations.AddAdminGuestActiveFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:account_users) do
      add :active, :boolean, default: false
      add :admin, :boolean, default: false
    end
  end
end
