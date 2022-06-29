defmodule Tictactoe.GatewayFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Tictactoe.Gateway` context.
  """

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{

      })
      |> Tictactoe.Gateway.create_game()

    game
  end
end
