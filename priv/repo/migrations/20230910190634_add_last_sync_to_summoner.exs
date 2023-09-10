defmodule ElevatedStats.Repo.Migrations.AddLastSyncToSummoner do
  use Ecto.Migration

  def change do
    alter table(:summoners) do
      add(:last_sync, :utc_datetime)
    end
  end
end
