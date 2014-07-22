require 'rails_helper'

describe Graph do
  before :each do
    @g = FactoryGirl.create(:graph)
  end

  it "should have a valid to_json method" do
    output = JSON.parse(@g.to_json)
    expect(output["kpis"]).to eq(Graph.KPI_LIST)
    puts output["data"]
    data = output["data"].flatten
    Graph.KPI_LIST.each do |kpi|
      expect(data).to include(kpi)
    end
    expect(output["providers"]).to eq(["'t3uk'"])
  end
end
