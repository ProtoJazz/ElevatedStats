defmodule ElevatedStats.Matches.Match do
  use Ecto.Schema
  import Ecto.Changeset

  # This line specifies a string primary key
  @primary_key {:id, :string, autogenerate: false}

  schema "matches" do
    field(:match_time, :utc_datetime)
    field(:queue_id, :integer)

    timestamps()
  end

  @doc false
  def changeset(match, attrs) do
    match
    |> cast(attrs, [:match_time, :queue_id, :id])
    |> validate_required([:match_time, :queue_id, :id])
  end
end
