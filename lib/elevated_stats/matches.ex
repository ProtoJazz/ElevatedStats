defmodule ElevatedStats.Matches do
  @moduledoc """
  The Matches context.
  """

  import Ecto.Query, warn: false
  alias ElevatedStats.Repo

  alias ElevatedStats.Matches.Match
  alias ElevatedStats.Matches.MatchParticipant
  alias ElevatedStats.MatchApi

  @doc """
  Returns the list of matches.

  ## Examples

      iex> list_matches()
      [%Match{}, ...]

  """
  def list_matches do
    Repo.all(Match)
  end

  @doc """
  Gets a single match.

  Raises `Ecto.NoResultsError` if the Match does not exist.

  ## Examples

      iex> get_match!(123)
      %Match{}

      iex> get_match!(456)
      ** (Ecto.NoResultsError)

  """
  def get_match!(id), do: Repo.get!(Match, id)

  @doc """
  Creates a match.

  ## Examples

      iex> create_match(%{field: value})
      {:ok, %Match{}}

      iex> create_match(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_match(attrs \\ %{}) do
    %Match{}
    |> Match.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a match.

  ## Examples

      iex> update_match(match, %{field: new_value})
      {:ok, %Match{}}

      iex> update_match(match, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_match(%Match{} = match, attrs) do
    match
    |> Match.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a match.

  ## Examples

      iex> delete_match(match)
      {:ok, %Match{}}

      iex> delete_match(match)
      {:error, %Ecto.Changeset{}}

  """
  def delete_match(%Match{} = match) do
    Repo.delete(match)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking match changes.

  ## Examples

      iex> change_match(match)
      %Ecto.Changeset{data: %Match{}}

  """
  def change_match(%Match{} = match, attrs \\ %{}) do
    Match.changeset(match, attrs)
  end

  alias ElevatedStats.Matches.MatchParticipant

  @doc """
  Returns the list of match_participants.

  ## Examples

      iex> list_match_participants()
      [%MatchParticipant{}, ...]

  """
  def list_match_participants do
    Repo.all(MatchParticipant)
  end

  @doc """
  Gets a single match_participant.

  Raises `Ecto.NoResultsError` if the Match participant does not exist.

  ## Examples

      iex> get_match_participant!(123)
      %MatchParticipant{}

      iex> get_match_participant!(456)
      ** (Ecto.NoResultsError)

  """
  def get_match_participant!(id), do: Repo.get!(MatchParticipant, id)

  @doc """
  Creates a match_participant.

  ## Examples

      iex> create_match_participant(%{field: value})
      {:ok, %MatchParticipant{}}

      iex> create_match_participant(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_match_participant(attrs \\ %{}) do
    %MatchParticipant{}
    |> MatchParticipant.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a match_participant.

  ## Examples

      iex> update_match_participant(match_participant, %{field: new_value})
      {:ok, %MatchParticipant{}}

      iex> update_match_participant(match_participant, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_match_participant(%MatchParticipant{} = match_participant, attrs) do
    match_participant
    |> MatchParticipant.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a match_participant.

  ## Examples

      iex> delete_match_participant(match_participant)
      {:ok, %MatchParticipant{}}

      iex> delete_match_participant(match_participant)
      {:error, %Ecto.Changeset{}}

  """
  def delete_match_participant(%MatchParticipant{} = match_participant) do
    Repo.delete(match_participant)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking match_participant changes.

  ## Examples

      iex> change_match_participant(match_participant)
      %Ecto.Changeset{data: %MatchParticipant{}}

  """
  def change_match_participant(%MatchParticipant{} = match_participant, attrs \\ %{}) do
    MatchParticipant.changeset(match_participant, attrs)
  end

  def filter_matches(matches) do
    query =
      from(i in Match,
        where: i.id in ^matches,
        select: i.id
      )

    existing_matches = Repo.all(query)
    matches -- existing_matches
  end

  def get_match_and_participants(match_id) do
    existing_match = Repo.get(Match, match_id)

    if(existing_match) do
      existing_match
    else
      match = MatchApi.get_match_by_id(match_id)

      create_match(%{
        "id" => match["metadata"]["matchId"],
        "match_time" => DateTime.from_unix!(match["info"]["gameCreation"], :millisecond),
        "queue_id" => match["info"]["queueId"]
      })

      Enum.each(match["info"]["participants"], fn participant ->
        damage_per_gold =
          if(participant["goldEarned"] != 0,
            do: participant["totalDamageDealt"] / participant["goldEarned"],
            else: 0
          )

        create_match_participant(%{
          "match_id" => match["metadata"]["matchId"],
          "champion_icon_id" => participant["championId"],
          "champion_name" => participant["championName"],
          "damage_dealt_to_turrets" => participant["damageDealtToTurrets"],
          "damage_per_gold" => damage_per_gold,
          "gold_earned" => participant["goldEarned"],
          "match_time" => DateTime.from_unix!(match["info"]["gameCreation"], :millisecond),
          "queue_id" => match["info"]["queueId"],
          "summoner_id" => participant["puuid"],
          "win" => participant["win"]
        })
      end)
    end
  end
end
