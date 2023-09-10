defmodule ElevatedStats.Repo.Migrations.CreateSummoners do
  use Ecto.Migration

  def change do
    create table(:summoners, primary_key: false) do
      add(:puuid, :string, primary_key: true)
      add(:summoner_name, :string)
      add(:level, :integer)
      add(:icon_id, :integer)
      add(:account_id, :integer)

      timestamps()
    end
  end
end
