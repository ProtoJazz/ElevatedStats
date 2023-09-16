defmodule ElevatedStats.Users.Summoner do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:puuid, :string, []}
  @derive {Phoenix.Param, key: :puuid}

  schema "summoners" do
    field(:icon_id, :integer)
    field(:level, :integer)
    field(:summoner_name, :string)
    field(:last_sync, :utc_datetime)
    belongs_to(:account, ElevatedStats.Users.Account)

    timestamps()
  end

  @doc false
  def changeset(summoner, attrs) do
    summoner
    |> cast(attrs, [:puuid, :summoner_name, :level, :icon_id, :account_id, :last_sync])
    |> validate_required([:puuid, :summoner_name, :level, :icon_id])
  end
end
