defmodule ElevatedStatsWeb.AccountJSON do
  alias ElevatedStats.Users.Account

  @doc """
  Renders a list of accounts.
  """
  def index(%{accounts: accounts}) do
    %{data: for(account <- accounts, do: data(account))}
  end

  @doc """
  Renders a single account.
  """
  def show(%{account: account}) do
    %{data: data(account)}
  end

  defp data(%Account{} = account) do
    %{
      id: account.id,
      summoner_name: account.summoner_name,
      puuid: account.puuid,
      region: account.region
    }
  end
end
