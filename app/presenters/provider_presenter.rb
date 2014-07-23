class ProviderPresenter < ChartPresenter
  def user_defined_headers
    providers
  end

  def kpi
    kpi.first
  end

  def squeeze_row(row, header = nil)
     row[kpi].to_i
  end
end
