require 'rails_helper'

describe Graph do
  KPI_LIST = [
    "total_sent",
    "total_sent_by_unique_customer",
    "total_imported",
    "applied",
    "not_confirmed",
    "issued"
  ]

  before :each do
    @query = FactoryGirl.create(:query)
    @new_query = FactoryGirl.create(:query , command: "SELECT id FROM customers LIMIT 10")
    @next_query = FactoryGirl.create(:query, command: "SELECT %{id} FROM customers LIMIT %{customers}")
    @g = Graph.new
    @g.query_id = 3
    @g.variables = {start_time: "2013-05-26 00:00:00", end_time: "2013-06-02 23:59:59", providers: "'t3uk'"}
    @g.save
  end

  it "should have a valid to_json method" do
    output = JSON.parse(@g.to_json)
    expect(output["kpis"]).to eq(KPI_LIST)
    data = output["data"].flatten
    KPI_LIST.each do |kpi|
      expect(data).to include(kpi)
    end
    expect(output["providers"]).to eq(["t3uk"])
  end
end
