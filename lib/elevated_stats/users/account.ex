defmodule ElevatedStats.Users.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field(:puuid, :string)
    field(:region, :string)
    field(:summoner_name, :string)
    has_one(:summoner, ElevatedStats.Users.Summoner)

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:summoner_name, :puuid, :region])
    |> validate_required([:summoner_name, :puuid, :region])
  end
end
