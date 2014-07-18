class CompleteQuery < ActiveRecord::Base
  belongs_to :query
  serialize :query_result, Array
  serialize :variables, Hash
end
