# Used when there are many kpis selected.
# Graphs all kpis over time on one chart
# If many providers are selected, aggragates their data

class KpiPresenter < ChartPresenter
  def user_defined_headers
    kpis
  end

  def extract_data(row)
    user_defined_headers.each do |header|
      @output[header][-1] += row[header].to_i
    end
  end
end

