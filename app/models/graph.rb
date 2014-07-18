class Graph < Widget
  belongs_to :query

  HEADER_LIST = [
    "provider",
    "tier",
    "date",
    "total_sent",
    "total_sent_by_unique_customer",
    "lead_source",
    "month",
    "type_cd",
    "sub_type_cd",
    "total_imported",
    "applied",
    "not_confirmed",
    "issued"
  ]
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

  N = 100

  def providers
    query_result.first(N).map { |row| row["provider"] }.uniq
  end

  def data
    headers = KPI_LIST
    data_hash = {}
    data_hash["x"] = []

    results = []
    headers.each { |header| results << [header] }
    query_result.first(N).each do |row|
      data_hash["x"] << row["date"]
      headers.each do |header|
        data_hash[header] << row[header]
      end
    end

    data_hash.map do |h, v|
      v.map! { |a| a.to_i } if INT_LIST.include? h
      [h, v.compact].flatten
    end
  end

  # data: [["column1", 1, 6... ], ["column2", 2, 5... ]]
  def as_json(options = {})
    execute_query if query_result.empty?
    {
      id: id,
      filter: "timeseries",
      y2: true,
      groups: [],
      providers: providers,
      data: data
    }
  end
end
