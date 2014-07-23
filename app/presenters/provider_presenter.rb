class ProviderPresenter < ChartPresenter
  def user_defined_headers
    providers
  end

  def kpi
    kpi.first
  end

  def extract_data(row, header = nil)
     row[kpi].to_i
  end
end
