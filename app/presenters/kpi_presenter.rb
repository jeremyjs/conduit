class KpiPresenter < ChartPresenter
  def user_defined_headers
    KPI_LIST
  end

  def milk(row)
    row[header].to_i
  end

end
