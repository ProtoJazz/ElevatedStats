defmodule ElevatedStats.MatchesTest do
  use ElevatedStats.DataCase

  alias ElevatedStats.Matches

  describe "matches" do
    alias ElevatedStats.Matches.Match

    import ElevatedStats.MatchesFixtures

    @invalid_attrs %{match_time: nil, queue_id: nil}

    test "list_matches/0 returns all matches" do
      match = match_fixture()
      assert Matches.list_matches() == [match]
    end

    test "get_match!/1 returns the match with given id" do
      match = match_fixture()
      assert Matches.get_match!(match.id) == match
    end

    test "create_match/1 with valid data creates a match" do
      valid_attrs = %{match_time: ~U[2023-09-15 00:30:00Z], queue_id: 42}

      assert {:ok, %Match{} = match} = Matches.create_match(valid_attrs)
      assert match.match_time == ~U[2023-09-15 00:30:00Z]
      assert match.queue_id == 42
    end

    test "create_match/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Matches.create_match(@invalid_attrs)
    end

    test "update_match/2 with valid data updates the match" do
      match = match_fixture()
      update_attrs = %{match_time: ~U[2023-09-16 00:30:00Z], queue_id: 43}

      assert {:ok, %Match{} = match} = Matches.update_match(match, update_attrs)
      assert match.match_time == ~U[2023-09-16 00:30:00Z]
      assert match.queue_id == 43
    end

    test "update_match/2 with invalid data returns error changeset" do
      match = match_fixture()
      assert {:error, %Ecto.Changeset{}} = Matches.update_match(match, @invalid_attrs)
      assert match == Matches.get_match!(match.id)
    end

    test "delete_match/1 deletes the match" do
      match = match_fixture()
      assert {:ok, %Match{}} = Matches.delete_match(match)
      assert_raise Ecto.NoResultsError, fn -> Matches.get_match!(match.id) end
    end

    test "change_match/1 returns a match changeset" do
      match = match_fixture()
      assert %Ecto.Changeset{} = Matches.change_match(match)
    end
  end

  describe "match_participants" do
    alias ElevatedStats.Matches.MatchParticipant

    import ElevatedStats.MatchesFixtures

    @invalid_attrs %{champion_icon_id: nil, champion_name: nil, damage_dealt_to_turrets: nil, damage_per_gold: nil, gold_earned: nil, match_id: nil, match_time: nil, queue_id: nil, summoner_id: nil, win: nil}

    test "list_match_participants/0 returns all match_participants" do
      match_participant = match_participant_fixture()
      assert Matches.list_match_participants() == [match_participant]
    end

    test "get_match_participant!/1 returns the match_participant with given id" do
      match_participant = match_participant_fixture()
      assert Matches.get_match_participant!(match_participant.id) == match_participant
    end

    test "create_match_participant/1 with valid data creates a match_participant" do
      valid_attrs = %{champion_icon_id: 42, champion_name: "some champion_name", damage_dealt_to_turrets: 42, damage_per_gold: 120.5, gold_earned: 120.5, match_id: "some match_id", match_time: ~U[2023-09-15 00:36:00Z], queue_id: 42, summoner_id: "some summoner_id", win: true}

      assert {:ok, %MatchParticipant{} = match_participant} = Matches.create_match_participant(valid_attrs)
      assert match_participant.champion_icon_id == 42
      assert match_participant.champion_name == "some champion_name"
      assert match_participant.damage_dealt_to_turrets == 42
      assert match_participant.damage_per_gold == 120.5
      assert match_participant.gold_earned == 120.5
      assert match_participant.match_id == "some match_id"
      assert match_participant.match_time == ~U[2023-09-15 00:36:00Z]
      assert match_participant.queue_id == 42
      assert match_participant.summoner_id == "some summoner_id"
      assert match_participant.win == true
    end

    test "create_match_participant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Matches.create_match_participant(@invalid_attrs)
    end

    test "update_match_participant/2 with valid data updates the match_participant" do
      match_participant = match_participant_fixture()
      update_attrs = %{champion_icon_id: 43, champion_name: "some updated champion_name", damage_dealt_to_turrets: 43, damage_per_gold: 456.7, gold_earned: 456.7, match_id: "some updated match_id", match_time: ~U[2023-09-16 00:36:00Z], queue_id: 43, summoner_id: "some updated summoner_id", win: false}

      assert {:ok, %MatchParticipant{} = match_participant} = Matches.update_match_participant(match_participant, update_attrs)
      assert match_participant.champion_icon_id == 43
      assert match_participant.champion_name == "some updated champion_name"
      assert match_participant.damage_dealt_to_turrets == 43
      assert match_participant.damage_per_gold == 456.7
      assert match_participant.gold_earned == 456.7
      assert match_participant.match_id == "some updated match_id"
      assert match_participant.match_time == ~U[2023-09-16 00:36:00Z]
      assert match_participant.queue_id == 43
      assert match_participant.summoner_id == "some updated summoner_id"
      assert match_participant.win == false
    end

    test "update_match_participant/2 with invalid data returns error changeset" do
      match_participant = match_participant_fixture()
      assert {:error, %Ecto.Changeset{}} = Matches.update_match_participant(match_participant, @invalid_attrs)
      assert match_participant == Matches.get_match_participant!(match_participant.id)
    end

    test "delete_match_participant/1 deletes the match_participant" do
      match_participant = match_participant_fixture()
      assert {:ok, %MatchParticipant{}} = Matches.delete_match_participant(match_participant)
      assert_raise Ecto.NoResultsError, fn -> Matches.get_match_participant!(match_participant.id) end
    end

    test "change_match_participant/1 returns a match_participant changeset" do
      match_participant = match_participant_fixture()
      assert %Ecto.Changeset{} = Matches.change_match_participant(match_participant)
    end
  end
end
