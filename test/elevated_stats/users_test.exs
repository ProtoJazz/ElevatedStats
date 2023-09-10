defmodule ElevatedStats.UsersTest do
  use ElevatedStats.DataCase

  alias ElevatedStats.Users

  describe "summoners" do
    alias ElevatedStats.Users.Summoner

    import ElevatedStats.UsersFixtures

    @invalid_attrs %{icon_id: nil, level: nil, puuid: nil, summoner_name: nil}

    test "list_summoners/0 returns all summoners" do
      summoner = summoner_fixture()
      assert Users.list_summoners() == [summoner]
    end

    test "get_summoner!/1 returns the summoner with given id" do
      summoner = summoner_fixture()
      assert Users.get_summoner!(summoner.id) == summoner
    end

    test "create_summoner/1 with valid data creates a summoner" do
      valid_attrs = %{icon_id: 42, level: 42, puuid: "some puuid", summoner_name: "some summoner_name"}

      assert {:ok, %Summoner{} = summoner} = Users.create_summoner(valid_attrs)
      assert summoner.icon_id == 42
      assert summoner.level == 42
      assert summoner.puuid == "some puuid"
      assert summoner.summoner_name == "some summoner_name"
    end

    test "create_summoner/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_summoner(@invalid_attrs)
    end

    test "update_summoner/2 with valid data updates the summoner" do
      summoner = summoner_fixture()
      update_attrs = %{icon_id: 43, level: 43, puuid: "some updated puuid", summoner_name: "some updated summoner_name"}

      assert {:ok, %Summoner{} = summoner} = Users.update_summoner(summoner, update_attrs)
      assert summoner.icon_id == 43
      assert summoner.level == 43
      assert summoner.puuid == "some updated puuid"
      assert summoner.summoner_name == "some updated summoner_name"
    end

    test "update_summoner/2 with invalid data returns error changeset" do
      summoner = summoner_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_summoner(summoner, @invalid_attrs)
      assert summoner == Users.get_summoner!(summoner.id)
    end

    test "delete_summoner/1 deletes the summoner" do
      summoner = summoner_fixture()
      assert {:ok, %Summoner{}} = Users.delete_summoner(summoner)
      assert_raise Ecto.NoResultsError, fn -> Users.get_summoner!(summoner.id) end
    end

    test "change_summoner/1 returns a summoner changeset" do
      summoner = summoner_fixture()
      assert %Ecto.Changeset{} = Users.change_summoner(summoner)
    end
  end

  describe "accounts" do
    alias ElevatedStats.Users.Account

    import ElevatedStats.UsersFixtures

    @invalid_attrs %{puuid: nil, region: nil, summoner_name: nil}

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Users.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Users.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      valid_attrs = %{puuid: "some puuid", region: "some region", summoner_name: "some summoner_name"}

      assert {:ok, %Account{} = account} = Users.create_account(valid_attrs)
      assert account.puuid == "some puuid"
      assert account.region == "some region"
      assert account.summoner_name == "some summoner_name"
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      update_attrs = %{puuid: "some updated puuid", region: "some updated region", summoner_name: "some updated summoner_name"}

      assert {:ok, %Account{} = account} = Users.update_account(account, update_attrs)
      assert account.puuid == "some updated puuid"
      assert account.region == "some updated region"
      assert account.summoner_name == "some updated summoner_name"
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_account(account, @invalid_attrs)
      assert account == Users.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Users.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Users.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Users.change_account(account)
    end
  end
end
