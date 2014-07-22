class KpiPresenter < ChartPresenter
  def process_data
    @output = Hash.new { |h, k| h[k] = [] }
    setup_data_headers
    group_query_result_by_date
    populate_output
    @output
  end

  def setup_data_headers
    @output["x"] << "x"
    user_defined_headers.each do |header|
      @output[header] << header
    end
  end

  def group_query_result_by_date
    setup_date_hash
    query_result.each do |row|
      extract_data_by_date(row)
    end
  end

  def setup_date_hash
    @result_grouped_by_date = Hash.new do |h, k|
      h[k] = Hash.new { |_h, _k| _h[_k] = 0 }
    end
  end

  def extract_data_by_date(row)
    user_defined_headers.each do |header|
      @result_grouped_by_date[row["date"]][header] += row[header].to_i
    end
  end

  def queries_sorted_by_date
    query_result.sort_by { |row| row["date"].to_date }
  end

  def extract_row_data(row)
    @output["x"] << row["date"]
    user_defined_headers.each do |header|
      @output[header] << row[header]
    end
  end

  def populate_output
    sorted_dates = @result_grouped_by_date.keys.sort_by(&:to_date)
    sorted_dates.each do |date|
      @output["x"] << date
      user_defined_headers.each do |header|
        @output[header] << @result_grouped_by_date[date][header]
      end
    end
  end
end
