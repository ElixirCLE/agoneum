defmodule Agoneum.GamesTest do
  use Agoneum.DataCase

  alias Agoneum.Games

  describe "games" do
    alias Agoneum.Games.Game

    @valid_attrs %{description: "some description", image: "some image", max_players: 42, min_players: 42, name: "some name", year: 42}
    @update_attrs %{description: "some updated description", image: "some updated image", max_players: 43, min_players: 43, name: "some updated name", year: 43}
    @invalid_attrs %{description: nil, image: nil, max_players: nil, min_players: nil, name: nil, year: nil}

    def game_fixture(attrs \\ %{}) do
      {:ok, game} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Games.create_game()

      game
    end

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Games.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Games.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      assert {:ok, %Game{} = game} = Games.create_game(@valid_attrs)
      assert game.description == "some description"
      assert game.image == "some image"
      assert game.max_players == 42
      assert game.min_players == 42
      assert game.name == "some name"
      assert game.year == 42
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      assert {:ok, game} = Games.update_game(game, @update_attrs)
      assert %Game{} = game
      assert game.description == "some updated description"
      assert game.image == "some updated image"
      assert game.max_players == 43
      assert game.min_players == 43
      assert game.name == "some updated name"
      assert game.year == 43
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Games.update_game(game, @invalid_attrs)
      assert game == Games.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Games.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Games.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Games.change_game(game)
    end
  end
end
