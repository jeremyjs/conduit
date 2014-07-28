require 'rails_helper'

KPI_LIST = [
  "total_sent",
  "total_sent_by_unique_customer",
  "total_imported",
  "applied",
  "not_confirmed",
  "issued"
]

describe Graph do
  skip

  let(:g) {FactoryGirl.create(:graph, variables: { kpis: KPI_LIST }) }

  it "should have a valid to_json method" do
    skip
    output = JSON.parse(g.to_json)
    expect(output["kpis"]).to eq(KPI_LIST)
    data = output["data"].flatten
    KPI_LIST.each do |kpi|
      expect(data).to include(kpi)
    end
    expect(output["providers"]).to eq(["'t3uk'"])
  end
end
