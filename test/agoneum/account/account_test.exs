defmodule Agoneum.AccountTest do
  use Agoneum.DataCase

  alias Agoneum.{Account, Account.User, Games}

  describe "users" do
    @valid_attrs %{email: "email@agoneum.com", name: "some name", password: "some password"}
    @update_attrs %{email: "updated@agoneum.com", name: "some updated name", password: "some updated password"}
    @invalid_attrs %{email: nil, name: nil, password_hash: nil}
    @game_attrs %{description: "Kill your friends", max_players: 7, min_players: 4, name: "BANG!", year: 2002}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_user()

      user
      |> Agoneum.Repo.preload(:games)
    end

    def game_fixture(attrs \\ %{}) do
      {:ok, game} =
        attrs
        |> Enum.into(@game_attrs)
        |> Games.create_game()

      game
      |> Agoneum.Repo.preload(:users)
    end

    test "list_users/0 returns all users" do
      users = Account.list_users()
      assert length(users) > 0

      user = List.first(users)
      assert %User{} = user
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert %User{id: id} = Account.get_user!(user.id)
      assert id == user.id
    end

    test "get_user_by_email/1 returns the user with that email" do
      user = user_fixture()
      assert %User{id: id} = Account.get_user_by_email(String.upcase(user.email))
      assert id == user.id
    end

    test "get_user_by_email/1 returns the user with that email if the given email is uppercase" do
      user = user_fixture()
      assert %User{id: id} = Account.get_user_by_email(String.upcase(user.email))
      assert id == user.id
    end

    test "get_user_by_email/1 returns nil when given nil" do
      assert Account.get_user_by_email(nil) == nil
    end

    test "get_user_by_email/1 returns nil when given non-existent email" do
      assert Account.get_user_by_email("what email") == nil
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Account.create_user(@valid_attrs)
      assert user.email == "email@agoneum.com"
      assert user.name == "some name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Account.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "updated@agoneum.com"
      assert user.name == "some updated name"
    end

    test "update_user/2 with a password updates the password" do
      user = user_fixture()
      assert {:ok, updated_user} = Account.update_user(user, %{password: "new_password"})
      refute user.password_hash == updated_user.password_hash
    end

    test "update_user/2 without a password update does not update the password" do
      user = user_fixture()
      assert {:ok, updated_user} = Account.update_user(user, %{email: "new_email@agoneum.com"})
      assert user.password_hash == updated_user.password_hash
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      updated_user = Account.get_user!(user.id)
      assert user.id == updated_user.id
      assert user.email == updated_user.email
      assert user.name == updated_user.name
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Account.change_user(user)
    end

    test "add_games/2 associates a game with the user" do
      user = user_fixture()
      game = game_fixture()
      assert length(user.games) == 0

      assert {:ok, user} = Account.add_games(user, game)
      assert length(user.games) == 1
    end

    test "add_games/2 adds new games to the user's list" do
      user = user_fixture()
      game = game_fixture()
      game2 = game_fixture(%{name: "BANG! High Noon"})

      {:ok, user} = Account.add_games(user, game)
      {:ok, user} = Account.add_games(user, game2)

      assert length(user.games) == 2
    end

    test "add_games/2 adds to a user's list of games without creating duplicates" do
      user = user_fixture()
      game = game_fixture()
      game2 = game_fixture(%{name: "BANG! High Noon"})
      assert length(user.games) == 0

      {:ok, user} = Account.add_games(user, game)
      {:ok, user} = Account.add_games(user, [game, game2])
      assert length(user.games) == 2
    end

    test "add_games/2 associates a game with multiple users" do
      user1 = user_fixture(%{email: "user1@agoneum.com", name: "User 1"})
      user2 = user_fixture(%{email: "user2@agoneum.com", name: "User 2"})
      game = game_fixture()

      assert {:ok, user1} = Account.add_games(user1, game)
      assert {:ok, user2} = Account.add_games(user2, game)

      assert List.first(user1.games).id == List.first(user2.games).id
    end
  end
end
