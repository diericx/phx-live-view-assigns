defmodule MyAppWeb.ThermostatLive do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_view
  use MyAppWeb, :live_view

  def mount(_params, _state, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 30000)

    {:ok, assign(socket, temperature: [])}
  end

  def render(assigns) do
    ~L"""
    Current temperatures:
    <%= for item <- @temperature do %>
      <p><%= item %></p>
    <% end %>
    <button phx-click="inc_temperature" phx-value-myvar1="val1">val1</button>
    <button phx-click="inc_temperature" phx-value-myvar1="val2">val2</button>
    """
  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 30000)
    {:noreply, assign(socket, :temperature, socket.assigns.temperature)}
  end

  def handle_event("inc_temperature", %{"myvar1" => var1}, socket) do
    {:noreply, assign(socket, :temperature, socket.assigns.temperature ++ [var1])}
  end
end