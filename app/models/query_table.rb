class QueryTable < Widget
  belongs_to :query

  def as_json(options)
    #if not self.query.query_result
    self.query.execute
    #end
    {
      id: self.id,
      hide: [
        "total_sent",
        "month",
      ],
      data: self.query.query_result.to_a
    }
  end
end
