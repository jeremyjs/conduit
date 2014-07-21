class Table < Widget

  def as_json(options)
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
