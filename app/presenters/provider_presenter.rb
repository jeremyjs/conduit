# Used when a single kpi is selected.
# Graphs the kpi of each provider over time on one chart

class ProviderPresenter < ChartPresenter
  def user_defined_headers
    providers
  end

  def kpi
    kpi[0]
  end

  def milk(row)
     row[kpi].to_i
  end
end
