class Table < Widget

  def as_json(options)
    if query_result.empty?
      execute_query
    end
    {
      id: id,
      hide: [
        "total_sent",
        "month",
      ],
      data: query_result
    }
  end
end
