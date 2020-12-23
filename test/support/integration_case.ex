defmodule SimpleHomeWeb.IntegrationCase do
  @moduledoc false
  use ExUnit.CaseTemplate

  using do
    quote do
      use SimpleHomeWeb.ConnCase
      use PhoenixIntegration
      import SimpleHome.Factory
    end
  end
end
