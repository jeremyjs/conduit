class KpiPresenter < ChartPresenter
  def user_defined_headers
    KPI_LIST
  end

  def milk(row, header)
    row[header].to_i
  end

end
