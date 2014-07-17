require 'rails_helper'

describe Query do
  it "is valid with valid attributes" do
    query = Query.new
    query.command = "Hello"
    expect(query).to be_valid
  end

 



end
