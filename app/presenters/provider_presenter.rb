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
