defmodule ElevatedStats.MatchesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ElevatedStats.Matches` context.
  """

  @doc """
  Generate a match.
  """
  def match_fixture(attrs \\ %{}) do
    {:ok, match} =
      attrs
      |> Enum.into(%{
        match_time: ~U[2023-09-15 00:30:00Z],
        queue_id: 42
      })
      |> ElevatedStats.Matches.create_match()

    match
  end

  @doc """
  Generate a match_participant.
  """
  def match_participant_fixture(attrs \\ %{}) do
    {:ok, match_participant} =
      attrs
      |> Enum.into(%{
        champion_icon_id: 42,
        champion_name: "some champion_name",
        damage_dealt_to_turrets: 42,
        damage_per_gold: 120.5,
        gold_earned: 120.5,
        match_id: "some match_id",
        match_time: ~U[2023-09-15 00:36:00Z],
        queue_id: 42,
        summoner_id: "some summoner_id",
        win: true
      })
      |> ElevatedStats.Matches.create_match_participant()

    match_participant
  end
end
