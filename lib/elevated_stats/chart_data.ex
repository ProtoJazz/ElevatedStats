defmodule ElevatedStats.ChartData do
  @derive {Jason.Encoder,
           only: [
             :lables,
             :towerDamage,
             :damagePerGold
           ]}
  defstruct lables: [], towerDamage: [], damagePerGold: []
end
