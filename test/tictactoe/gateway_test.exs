defmodule Tictactoe.GatewayTest do
  use Tictactoe.DataCase

  alias Tictactoe.Gateway

  describe "games" do
    alias Tictactoe.Gateway.Game

    import Tictactoe.GatewayFixtures

    @invalid_attrs %{}

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Gateway.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Gateway.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      valid_attrs = %{}

      assert {:ok, %Game{} = game} = Gateway.create_game(valid_attrs)
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Gateway.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      update_attrs = %{}

      assert {:ok, %Game{} = game} = Gateway.update_game(game, update_attrs)
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Gateway.update_game(game, @invalid_attrs)
      assert game == Gateway.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Gateway.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Gateway.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Gateway.change_game(game)
    end
  end
end
