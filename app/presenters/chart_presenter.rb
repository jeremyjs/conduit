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
    query_result.first.keys
  end

  def providers
    [ variables[:providers] ].flatten
  end

  def kpis
    variables[:kpis] || KPI_LIST
  end

  def user_defined_headers
    KPI_LIST
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

  # data: [["column1", 1, 6... ], ["column2", 2, 5... ]]
  def data
    {
      variables: variables,
      headers: headers,
      kpis: kpis,
      providers: providers,
      query: query.name,
      id: id,
      filters: ["bar"],
      groups: nil,
      example_result_hash: query_result.first,
      data: process_data
    }
  end

  def to_json
    # @graph.execute_query if query_result.empty?
    data
  end

  def self.presenter_for(datatype)
    kpis.count == 1 ? KpisPresenter : ProvidersPresenter
  end
end

