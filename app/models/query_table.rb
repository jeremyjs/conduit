class QueryTable < Widget
  belongs_to :query

  after_update :query_changed

  def initialize(attributes = {})
    super
    self.query_id ||= 3
  end

  def query_changed
    if self.query_id_changed?
      self.query.execute
      self.query.save
    end
  end

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
