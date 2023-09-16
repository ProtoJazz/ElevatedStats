defmodule ElevatedStats.Repo.Migrations.CreateMatchParticipants do
  use Ecto.Migration

  def change do
    create table(:match_participants) do
      add :queue_id, :integer
      add :damage_dealt_to_turrets, :integer
      add :match_time, :utc_datetime
      add :gold_earned, :float
      add :champion_name, :string
      add :champion_icon_id, :integer
      add :win, :boolean, default: false, null: false
      add :summoner_id, :string
      add :match_id, :string
      add :damage_per_gold, :float

      timestamps()
    end
  end
end
