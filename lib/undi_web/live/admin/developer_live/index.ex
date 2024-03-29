defmodule UndiWeb.Admin.DeveloperLive.Index do
    @moduledoc """
    The admin Developer index page.
    """
    use UndiWeb, :live_view
  
    @impl true
    def mount(_params, _session, socket) do
      {:ok, socket}
    end
  
    @impl true
    def handle_params(params, _url, socket) do
      {
        :noreply,
        socket
        |> assign(:params, params)
        |> assign(:page_title, "Developer Page")
      }
    end
  end