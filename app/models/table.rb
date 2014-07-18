class Table < Widget

  def as_json(options)
    {
      id: self.id,
      hide: [
        "total_sent",
        "month",
      ],
      data: self.query_result
    }
  end
end
