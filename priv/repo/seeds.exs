# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Agoneum.Repo.insert!(%Agoneum.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Agoneum.Account.User

Agoneum.Repo.insert!(
  %User{
    email: "admin@agoneum.com",
    name: "Admin",
    password_hash: Comeonin.Bcrypt.hashpwsalt("admin1"),
    admin: true
  }
)
