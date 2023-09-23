defmodule UndiWeb.Layouts do
  @moduledoc false
  use UndiWeb, :html

  embed_templates "layouts/*"
  defp admin_nav_items do
    [
      %{label: "Admin", icon: "hero-presentation-chart-line", path: ~p"/admin"},
      %{label: "Users", icon: "hero-user", path: ~p"/admin/users"},
      %{label: "Accounts", icon: "hero-users", path: ~p"/admin/accounts"},
      %{label: "Admins", icon: "hero-identification", path: ~p"/admin/admins"},
      %{label: "Developers", icon: "hero-beaker", path: ~p"/admin/developers"},
      ## Insert admin nav items below ##
    ]
  end
end
