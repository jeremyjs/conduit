# Used when there are many kpis selected.
# Graphs all kpis over time on one chart
# If many providers are selected, aggragates their data

class KpiPresenter < ChartPresenter
  def process_data
    @output = Hash.new { |hash, key| hash[key] = [key] }
    query_result.sort_by! { |row| row["date"] }
    query_result.each do |row|
      populate_row_headers_for(row) if row["date"] != @output["x"][-1]
      user_defined_headers.each { |header| @output[header][-1] += row[header].to_i }
    end

    @output.values
  end

  private

  def populate_row_headers_for(row)
    @output["x"] << row["date"]
    user_defined_headers.each { |header| @output[header] << 0 }
  end
end

