# Used when there are many kpis selected.
# Graphs all kpis over time on one chart
# If many providers are selected, aggragates their data

class KpiPresenter < ChartPresenter
  def user_defined_headers
    KPI_LIST
  end

  def milk(row)
    row[header].to_i
  end
end

