class ChartPresenter
  INT_LIST = [
    "total_sent",
    "total_sent_by_unique_customer",
    "lead_source",
    "month",
    "total_imported",
    "applied",
    "not_confirmed",
    "issued"
  ]

  def initialize(graph = nil)
    @graph = graph
  end

  def headers
    query_result.first ? query_result.first.keys : []
  end

  def providers
    [ Widget.s_to_a(@graph.display_providers) ].flatten
  end

  def self.kpi_list
    [ "total_sent",
      "total_sent_by_unique_customer",
      "total_imported",
      "applied",
      "not_confirmed",
      "issued" ]
  end

  def kpi_list
    ChartPresenter.kpi_list
  end

  def kpis
    @graph.kpis
  end

  def kpi
    kpis && kpis.length == 1 && kpis.first || nil
  end

  def variables
    @graph.variables
  end

  def id
    @graph.id
  end

  def query_result
    @graph.query_result || []
  end

  def query
    @graph.query
  end

  def display_variables
    @graph.display_variables
  end

  def start_time
    variables[:start_time]
  end
  alias :start_date :start_time

  def end_time
    variables[:end_time]
  end
  alias :end_date :end_time

  def first_date
    Date.parse(start_date)
  end

  def last_date
    Date.parse(end_date)
  end

  def formatted_query_results
    return @output.values if @output
    @output = Hash.new { |hash, key| hash[key] = [key] }
    selected_provider_data = query_result.select { |row| providers.include? row["provider"] }
    selected_provider_data.sort_by! { |row| row["date"] }
    p selected_provider_data
    selected_provider_data.each do |row|
      populate_row_headers_for(row) if row["date"] != @output["x"][-1]
      extract_data(row)
    end

    fill_in_until_including(end_date)

    @output.values
  end

  # data: [["column1", 1, 6... ], ["column2", 2, 5... ]]
  def to_json
    {
      variables: variables,
      headers: headers,
      user_defined_headers: user_defined_headers,
      kpis: kpis,
      weekly: group_weekly(formatted_query_results),
      totals: totals,
      percentage: percentagize(formatted_query_results),
      display_variables: display_variables,
      providers: providers,
      query: query.name,
      id: id,
      filters: ["percent"],
      groups: nil,
      example_result_hash: query_result.first,
      data1: formatted_query_results,
      data: percentagize(formatted_query_results)
    }
  end

  private
  def totals
    return @totals if @totals
    @totals = {}
    kpi_list.each { |kpi| @totals[kpi] = [0] }
    sorted_query_result = query_result.sort_by { |row| row["date"] }
    @date_iterator = formatted_query_results[0][1..-1].each
    sorted_query_result.each { |row| extract_kpis(row) }
    @totals
  end

  def extract_kpis(query_row)
    while @date_iterator.peek != query_row["date"]
      puts @date_iterator.peek
      @date_iterator.next
      @totals.values.each { |a| a << 0 }
    end
    kpi_list.each { |kpi| @totals[kpi][-1] += query_row[kpi].to_i }
  end

  def percentagize(input)
    rows = input.clone
    date_row = rows.shift
    rows.map! { |row| apply_percentages(row) }
    rows.unshift date_row
  end

  def apply_percentages(row)
    apply_percentages!(row.clone)
  end

  def apply_percentages!(row)
    header = row.shift
    kpi = if kpi_list.include? header
            header
          else
            self.kpi
          end
    new_row = row.map.with_index do |v, i|
      total = totals[kpi][i].to_f
      total == 0 ? 0 : v/total
    end
    new_row.unshift header
  end

  def fill_in_until_including(date)
    date = Date.parse(date) unless date.is_a? Date
    if @output["x"].last == "x"
      most_recent_start_date = Date.parse(start_time)
    else
      most_recent_start_date = Date.parse(@output["x"].last) + 1
    end
    (most_recent_start_date..date).each do |d|
      @output["x"] << d.to_s
      user_defined_headers.each { |header| @output[header] << 0 }
    end
  end

  def populate_row_headers_for(row)
    fill_in_until_including(row["date"])
  end

  def group_weekly(rows)
    group_weekly!(rows.clone)
  end

  def group_weekly!(rows)
    @interval = 7 # days
    rows.shift
    headers = rows.map { |row| row.clone.shift }
    new_date_row = ["x"]
    new_rows = []

    (0..num_intervals).each do |new_date_index|
      new_date_row << formatted_date_label(new_date_index)
    end

    rows.each_with_index do |row, i|
      new_rows << [headers[i]]
      (1...new_date_row.length).each do |new_date_index|
        new_rows.last << row_sum(row, new_date_index)
      end
    end
    new_rows.unshift new_date_row
    new_rows
  end

  def group_biweekly(rows)
    rows.group_by_week(:date)
  end

  def group_monthly(rows)
    rows.group_by_week(:date)
  end

  def num_intervals
    ((last_date - first_date) / @interval).to_i
  end

  def first_date_range
  end

  def row_sum(row, new_date_index)
    row_segment = row[(new_date_index * @interval)...(new_date_index * (@interval + 1))]
    row_segment = row[(num_intervals * @interval)..-1] if new_date_index > num_intervals
    row_segment.shift if row_segment[0].is_a? String
    row_segment.inject{ |sum, v| sum + v.to_i }
  end

  def formatted_date_label(new_date_index)
    first_date_in_interval, second_date_in_interval = nearest_calendar_week(first_date + new_date_index * @interval)
    first_date_in_interval = first_date if new_date_index == 0
    second_date_in_interval = last_date if new_date_index == num_intervals

    formatted_first_date  = first_date_in_interval.strftime("%-m/%-d")
    formatted_second_date = second_date_in_interval.strftime("%-m/%-d")

    "#{formatted_first_date} - #{formatted_second_date}"
  end

  def nearest_calendar_week(date)
    [date.beginning_of_week, date.beginning_of_week + 6]
  end
end

