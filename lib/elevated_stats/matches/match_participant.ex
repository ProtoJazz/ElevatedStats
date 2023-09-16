defmodule ElevatedStats.Matches.MatchParticipant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "match_participants" do
    field :champion_icon_id, :integer
    field :champion_name, :string
    field :damage_dealt_to_turrets, :integer
    field :damage_per_gold, :float
    field :gold_earned, :float
    field :match_id, :string
    field :match_time, :utc_datetime
    field :queue_id, :integer
    field :summoner_id, :string
    field :win, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(match_participant, attrs) do
    match_participant
    |> cast(attrs, [:queue_id, :damage_dealt_to_turrets, :match_time, :gold_earned, :champion_name, :champion_icon_id, :win, :summoner_id, :match_id, :damage_per_gold])
    |> validate_required([:queue_id, :damage_dealt_to_turrets, :match_time, :gold_earned, :champion_name, :champion_icon_id, :win, :summoner_id, :match_id, :damage_per_gold])
  end
end
