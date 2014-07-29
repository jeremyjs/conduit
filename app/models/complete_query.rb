class CompleteQuery < ActiveRecord::Base
  belongs_to :query
  serialize :query_result, Array
  serialize :variables, Hash

  def fresh?
    TimeDifference.between(last_executed, Time.now).in_days < 1
  end
end
