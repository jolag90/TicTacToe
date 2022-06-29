defmodule TictactoeWeb.GameLive.Index do
  use TictactoeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, reset_game(socket)}
  end

  def draw_board(assigns) do
    ~H"""
    <div class="board">
      <%= for {field, symbol} <- @board do %>
        <div class="cell"
          phx-click="move"
          phx-value-field={field}
          phx-value-symbol={symbol}
            ><%=(symbol || raw("&nbsp;"))%></div>


      <% end %>
     </div>
    """
  end

  @impl true
  def handle_event("move", %{"field" => _field, "symbol" => _symbol}, socket) do
    socket =
      if not socket.assigns.restart do
        socket |> assign(:message, "already in use")
      else
        socket |> assign(:message, socket.assigns.message <> "<br>GAME OVER")
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("move", %{"field" => field}, socket) do
    socket =
      if not socket.assigns.restart do
        case Cheapchess.make_a_move({:ok, socket.assigns.board}, field, socket.assigns.player) do
          {:ok, board} ->
            new_player = Cheapchess.change_player(socket.assigns.player)

            socket
            |> assign(
              :message,
              "good move, #{socket.assigns.player}! <br> #{new_player} your turn!"
            )
            |> assign(:board, board)
            |> assign(:player, new_player)

          {:won, board} ->
            socket
            |> assign(:message, "#{socket.assigns.player} won!!!!")
            |> assign(:board, board)
            |> assign(:restart, true)

          {:draw, board} ->
            socket
            |> assign(:message, "it is a draw")
            |> assign(:board, board)
            |> assign(:restart, true)

          rc ->
            socket |> assign(:message, inspect(rc))
        end
      else
        socket
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("restart", _params, socket) do
    {:noreply, reset_game(socket)}
  end

  defp reset_game(socket) do
    {:ok, board} = Cheapchess.initialize()

    socket
    |> assign(:board, board)
    |> assign(:player, "X")
    |> assign(:message, "player X start")
    |> assign(:restart, false)
  end
end
