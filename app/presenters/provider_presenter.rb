# Used when a single kpi is selected.
# Graphs the kpi of each provider over time on one chart

class ProviderPresenter < ChartPresenter
  def user_defined_headers
    providers
  end

  def kpi
    kpis.first
  end

  def extract_data(row, header = nil)
    @output[row["provider"]][-1] += row[kpi].to_i
  end
end
