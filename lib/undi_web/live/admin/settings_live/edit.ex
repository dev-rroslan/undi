defmodule UndiWeb.Admin.SettingLive.Edit do
    @moduledoc """
    The admin settings page for updating email and password
    """
    use UndiWeb, :live_view
  
    alias Undi.Admins
  
    @impl true
    def mount(_params, %{"current_admin_id" => id}, socket) do
      admin = Admins.get_admin!(id)
  
      {
        :ok,
        socket
        |> assign(:page_title, "Settings")
        |> assign(:admin, admin)
      }
    end
  end