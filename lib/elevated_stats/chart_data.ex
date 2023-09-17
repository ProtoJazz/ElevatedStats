defmodule ElevatedStats.ChartData do
  @derive {Jason.Encoder,
           only: [
             :lables,
             :towerDamage,
             :damagePerGold,
             :icons
           ]}
  defstruct lables: [], towerDamage: [], damagePerGold: [], icons: []
end
