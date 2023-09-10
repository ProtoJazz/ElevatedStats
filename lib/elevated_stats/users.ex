defmodule ElevatedStats.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias ElevatedStats.Repo

  alias ElevatedStats.Users.Summoner

  @doc """
  Returns the list of summoners.

  ## Examples

      iex> list_summoners()
      [%Summoner{}, ...]

  """
  def list_summoners do
    Repo.all(Summoner)
  end

  @doc """
  Gets a single summoner.

  Raises `Ecto.NoResultsError` if the Summoner does not exist.

  ## Examples

      iex> get_summoner!(123)
      %Summoner{}

      iex> get_summoner!(456)
      ** (Ecto.NoResultsError)

  """
  def get_summoner!(id), do: Repo.get!(Summoner, id)

  @doc """
  Creates a summoner.

  ## Examples

      iex> create_summoner(%{field: value})
      {:ok, %Summoner{}}

      iex> create_summoner(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_summoner(attrs \\ %{}) do
    %Summoner{}
    |> Summoner.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a summoner.

  ## Examples

      iex> update_summoner(summoner, %{field: new_value})
      {:ok, %Summoner{}}

      iex> update_summoner(summoner, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_summoner(%Summoner{} = summoner, attrs) do
    summoner
    |> Summoner.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a summoner.

  ## Examples

      iex> delete_summoner(summoner)
      {:ok, %Summoner{}}

      iex> delete_summoner(summoner)
      {:error, %Ecto.Changeset{}}

  """
  def delete_summoner(%Summoner{} = summoner) do
    Repo.delete(summoner)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking summoner changes.

  ## Examples

      iex> change_summoner(summoner)
      %Ecto.Changeset{data: %Summoner{}}

  """
  def change_summoner(%Summoner{} = summoner, attrs \\ %{}) do
    Summoner.changeset(summoner, attrs)
  end

  alias ElevatedStats.Users.Account

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts do
    Repo.all(Account)
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}) do
    # Get puuid -> create summoner
    summoner_resp = ElevatedStats.SummonerApi.get_summoner_by_name(attrs["summoner_name"])

    {:ok, account} =
      %Account{}
      |> Account.changeset(%{
        "puuid" => summoner_resp["puuid"],
        "region" => "na1",
        "summoner_name" => attrs["summoner_name"]
      })
      |> Repo.insert()

    create_summoner(%{
      "puuid" => summoner_resp["puuid"],
      "summoner_name" => summoner_resp["name"],
      "level" => summoner_resp["summonerLevel"],
      "icon_id" => summoner_resp["profileIconId"],
      "account_id" => account.id
    })

    {:ok, account}
  end

  def get_summoners_to_sync() do
    sync_time = DateTime.utc_now() |> DateTime.add(-1, :hour)

    query =
      from(a in Summoner,
        where: is_nil(a.last_sync) or a.last_sync < ^sync_time,
        select: a
      )

    Repo.all(query)
  end

  def get_matches_for_summoner(%Summoner{} = summoner) do
    ElevatedStats.MatchApi.get_matches_for_summoner(summoner.puuid)
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{data: %Account{}}

  """
  def change_account(%Account{} = account, attrs \\ %{}) do
    Account.changeset(account, attrs)
  end
end
