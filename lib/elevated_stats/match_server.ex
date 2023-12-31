defmodule ElevatedStats.MatchServer do
  use GenServer
  alias ElevatedStats.{Summoner, Users, Matches}

  defmodule State do
    defstruct summoner_queue: [],
              match_queue: [],
              rate_limit: 100,
              rate_limit_remaining: 100,
              rate_limit_reset: 120
  end

  def start_link(_args) do
    IO.puts("STARTING MATCH SERVER")
    GenServer.start_link(__MODULE__, %State{}, name: __MODULE__)
  end

  def init(state) do
    state = update_users(state)
    IO.puts("OK, so we got some shit to sync. ")
    IO.inspect(state.summoner_queue)
    # :timer.hours(1)
    schedule_sync(:timer.seconds(5))
    handle_rate_limit_refresh(state.rate_limit_reset)
    {:ok, state}
  end

  def get_matches_for_summoner(state) do
    [summoner | remaning_summoners] = state.summoner_queue

    Users.get_matches_for_summoner(summoner)
    |> handle_match_list(state, remaning_summoners)
  end

  def handle_match_list(matches, state, remaning_summoners) when is_list(matches) do
    matches = Matches.filter_matches(matches)
    schedule_sync(:timer.seconds(0))

    %State{
      state
      | summoner_queue: remaning_summoners,
        match_queue: matches,
        rate_limit_remaining: state.rate_limit_remaining - 1
    }
  end

  def handle_match_list(matches, state, _remaning_summoners) when is_map(matches) do
    schedule_sync(:timer.seconds(0))
    rate_limit_exceeded(state)
  end

  def update_users(state) do
    summoner_queue = Users.get_summoners_to_sync()
    state = %{state | summoner_queue: summoner_queue}
  end

  def sync_match_async(state) do
    [match | remaining_matches] = state.match_queue

    # Task.async(fn match -> Matches.get_match_and_participants(match) end)
    Matches.get_match_and_participants(match)

    %State{
      state
      | match_queue: remaining_matches,
        rate_limit_remaining: state.rate_limit_remaining - 1
    }
  end

  def handle_info(:start_syncing, state) do
    IO.puts("DOING A SYNC")
    IO.inspect(state)

    state =
      cond do
        state.rate_limit_remaining <= 0 ->
          IO.puts("rate limit used up, sleep now")
          schedule_sync(:timer.seconds(60))
          state

        Enum.count(state.match_queue) <= 0 && Enum.count(state.summoner_queue) <= 0 ->
          IO.puts("queues are empty, check for new users, or sleep")
          state = update_users(state)

          if(Enum.count(state.summoner_queue) > 0) do
            schedule_sync(0)
            state
          else
            schedule_sync(:timer.seconds(120))
            state
          end

        Enum.count(state.match_queue) > 0 ->
          IO.puts("we got matches to sync")
          state = sync_match_async(state)
          schedule_sync(500)
          state

        Enum.count(state.summoner_queue) > 0 ->
          IO.puts("we got summoners to sync")
          get_matches_for_summoner(state)
      end

    {:noreply, state}
  end

  def rate_limit_exceeded(state) do
    %State{state | rate_limit_remaining: 0}
  end

  def new_user_added() do
    GenServer.call(__MODULE__, :update_users)
  end

  def handle_call(:update_users, _, state) do
    state = update_users(state)
    {:reply, state, state}
  end

  def handle_info(:rate_limit_exceeded, state) do
    IO.puts("RATE LIMIT EXCEEDED")
    {:noreply, rate_limit_exceeded(state)}
  end

  def handle_info(:refresh_rate_limit, state) do
    Process.send_after(self(), :refresh_rate_limit, :timer.seconds(state.rate_limit_reset))
    {:noreply, %State{state | rate_limit_remaining: state.rate_limit}}
  end

  defp handle_rate_limit_refresh(time) do
    Process.send_after(self(), :refresh_rate_limit, time)
  end

  defp schedule_sync(time) do
    # Process.send_after(self(), :start_syncing, time)
  end
end
