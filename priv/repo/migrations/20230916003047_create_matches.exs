defmodule ElevatedStats.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches, primary_key: false) do
      add(:match_time, :utc_datetime)
      add(:queue_id, :integer)
      add(:id, :string, primary_key: true)
      timestamps()
    end
  end
end
