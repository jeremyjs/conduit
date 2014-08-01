require 'rails_helper'

RSpec.describe CompleteQuery, :type => :model do

    let(:first_query) {FactoryGirl.create(:query, command: "SELECT id FROM customers LIMIT 5")}
    let(:second_query) {FactoryGirl.create(:query, command: "SELECT id FROM customers LIMIT 10")}
    let(:first_widget) {FactoryGirl.create(:widget , query_id: first_query.id)}
    let(:complete_query_first) {CompleteQuery.find_by(query_id: first_widget.query_id)}

    before :each do
      complete_query_first.query_id = first_query.id
    end

    it "should be created once a query which is being executed for the first time has finished" do
      expect(complete_query_first.variables).to eq(first_widget.variables)
      expect(complete_query_first.query_result).to eq(first_widget.query_result)
      expect(complete_query_first.last_executed).to eq(first_widget.last_executed)
    end

    it "belongs to the query whose query id it has" do
      expect(first_query.complete_queries.first).to eq(complete_query_first)
    end

    it "should be the only completed query in response to a single query" do
      completed_queries = CompleteQuery.where(query_id: first_query.id)
      expect(completed_queries.count).to eq(1)
    end

end
