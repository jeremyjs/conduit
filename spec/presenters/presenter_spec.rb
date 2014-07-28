require 'rails_helper'

describe KpiPresenter do
  before :each do
    @g = FactoryGirl.create(:graph, variables: {})
    @q = FactoryGirl.create(:query, command: "SELECT id FROM customers LIMIT 10")
    @g_dates = FactoryGirl.create(:graph)
    @g_results = FactoryGirl.create(:graph, query_id: @q.id, variables: {})
  end

  it "should have valid data" do
    skip
    total_imported_query = @g_dates.query_result.inject(0) { |sum, row| sum + row["total_imported"].to_i }
    data = JSON.parse(@g_dates.to_json)["data"]
    index = data.index { |column| column[0] == "total_imported" }
    data[index].shift if data[index].first
    total_imported_data = data[index].inject(&:+)
    expect(total_imported_data).to eq(total_imported_query)
  end

  it "should be able to process an empty result" do
    expect(JSON.parse(@g.to_json)).to_not eq(nil)
  end

  it "should be sorted by date" do
    data = JSON.parse(@g_dates.to_json)["data"]
    data[0].shift
    dates = data[0]
    expect(dates.sort_by { |s| s.to_date }).to eq(dates)
  end
end

describe ProviderPresenter do
  pending "add some examples to (or delete) #{__FILE__}"
end
