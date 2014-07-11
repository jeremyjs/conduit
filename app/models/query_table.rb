class QueryTable < Widget
  belongs_to :query

  def as_json(options)
    if self.query.query_result.empty?
      self.query.execute
      self.query.save
    end
    {
      id: self.id,
      hide: [
        "total_sent",
        "month",
      ],
      data: self.query.query_result
    }
  end
end
