defmodule ElevatedStats.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :summoner_name, :string
      add :puuid, :string
      add :region, :string

      timestamps()
    end
  end
end
