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
  KPI_LIST = [
    "total_sent",
    "total_sent_by_unique_customer",
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
    [ variables[:providers] ].flatten
  end

  def kpis
    variables[:kpis] || KPI_LIST
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

  def process_data
    @output = Hash.new { |hash, key| hash[key] = [key] }
    query_result.sort_by! { |row| row["date"] }
    query_result.each do |row|
      populate_row_headers_for(row) if row["date"] != @output["x"][-1]
      user_defined_headers.each { |header| @output[header][-1] += extract_data(row, header) }
    end

    @output.values
  end

  # data: [["column1", 1, 6... ], ["column2", 2, 5... ]]
  def to_json
    {
      variables: variables,
      headers: headers,
      udhs: user_defined_headers,
      kpis: kpis,
      # dv: display_variables,
      providers: providers,
      query: query.name,
      id: id,
      filters: [],
      groups: nil,
      example_result_hash: query_result.first,
      data: process_data
    }
  end

  private

  def populate_row_headers_for(row)
    @output["x"] << row["date"]
    user_defined_headers.each { |header| @output[header] << 0 }
  end
end
