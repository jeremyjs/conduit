class Table < Widget


  def initialize(attributes = {})
    super
    self.query_id ||= 3
  end


  def as_json(options)
    if self.query_result.empty?
      self.execute_query
    end
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
