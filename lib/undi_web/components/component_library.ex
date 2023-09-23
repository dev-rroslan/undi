defmodule UndiWeb.ComponentLibrary do
  defmacro __using__(_) do
    quote do
      import UndiWeb.ComponentLibrary
      import UndiWeb.Components.Admin
      import UndiWeb.Components.Cards
      import UndiWeb.Components.Tables
      import UndiWeb.Components.Dropdowns
      # Import additional component modules below

    end
  end
  @moduledoc """
  This module is added and used in UndiWeb. The idea is
  different component modules can be added and imported in the macro section above.
  """
  use Phoenix.Component

end
