class CompleteQuery < ActiveRecord::Base
  belongs_to :query
  serialize :query_result, Array
  serialize :variables, Hash


  def initialize(attributes = {})
    super
    self.always_fresh ||= false
  end

  def fresh?
    always_fresh ||
    TimeDifference.between(last_executed, Time.now).in_days < 1
  end
end
