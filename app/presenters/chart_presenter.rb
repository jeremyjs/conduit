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
    if query_result && query_result.first
      query_result.first.keys
    else
      []
    end
  end

  def providers
    [ @graph.providers ].flatten
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

  def variables
    @graph.variables
  end

  def id
    @graph.id
  end

  def query_result
    @graph.query_result
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

  def process_data
    @output = Hash.new { |hash, key| hash[key] = [key] }
    selected_provider_data = query_result.select { |row| providers.include? row[provider] }
    selected_provider_data.sort_by! { |row| row["date"] }
    selected_provider_data.each do |row|
      populate_row_headers_for(row) if row["date"] != @output["x"][-1]
      extract_data(row)
    end

    fill_in_until_including(end_date)

    @output.values
  end

  def totals
    @totals = Hash.new { 0 }
    query_result.each { |row| extract_kpis(row) }
    @totals
  end

  def extract_kpis(row)
    kpis.each { |kpi| @totals[kpi] += row[kpi].to_i }
  end

  # data: [["column1", 1, 6... ], ["column2", 2, 5... ]]
  def to_json
    {
      variables: variables,
      headers: headers,
      user_defined_headers: user_defined_headers,
      kpis: kpis,
      display_variables: display_variables,
      providers: providers,
      query: query.name,
      id: id,
      filters: [],
      groups: nil,
      example_result_hash: query_result.first,
      data: process_data,
      totals: totals
    }
  end

  private
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
end

