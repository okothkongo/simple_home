defmodule SimpleHomeWeb.FeatureCase do
  @moduledoc false
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.Feature
      import Wallaby.Query
      # import SimpleHomeWeb.FeatureCase 
      alias SimpleHomeWeb.Router.Helpers, as: Routes

      @endpoint SimpleHomeWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(SimpleHome.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(SimpleHome.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(SimpleHome.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    {:ok, session: session}
  end
end
