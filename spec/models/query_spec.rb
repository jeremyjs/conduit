require 'rails_helper'

describe Query do

  before :each do
    @query = FactoryGirl.create(:query)
  end

  it "is valid with valid attributes" do
    expect(query).to be_valid
  end

 



end
