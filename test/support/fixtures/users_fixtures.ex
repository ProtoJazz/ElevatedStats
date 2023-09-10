defmodule ElevatedStats.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ElevatedStats.Users` context.
  """

  @doc """
  Generate a summoner.
  """
  def summoner_fixture(attrs \\ %{}) do
    {:ok, summoner} =
      attrs
      |> Enum.into(%{
        icon_id: 42,
        level: 42,
        puuid: "some puuid",
        summoner_name: "some summoner_name"
      })
      |> ElevatedStats.Users.create_summoner()

    summoner
  end

  @doc """
  Generate a account.
  """
  def account_fixture(attrs \\ %{}) do
    {:ok, account} =
      attrs
      |> Enum.into(%{
        puuid: "some puuid",
        region: "some region",
        summoner_name: "some summoner_name"
      })
      |> ElevatedStats.Users.create_account()

    account
  end
end
