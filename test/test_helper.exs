ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(SimpleHome.Repo, :manual)
Application.put_env(:wallaby, :base_url, SimpleHomeWeb.Endpoint.url())
{:ok, _} = Application.ensure_all_started(:wallaby)
