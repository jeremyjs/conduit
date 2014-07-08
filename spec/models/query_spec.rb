require 'rails_helper'

describe Query do
  it "is valid with valid attributes" do
    query = Query.new
    query.command = "Hello"
    expect(query).to be_valid
  end

  it {should have_many(:query_tables)}

  it "should return a postgres result which is stored in query_result on executing its command" do
    query = Query.new
    query.command = "SELECT id from customers ORDER BY id LIMIT 1"
    query.execute
    expect(query.query_result).to be_a(PG::Result)
  end

  it "should execute the command correctly" do
    query = Query.new
    query.command = "SELECT id FROM customers ORDER BY id LIMIT 1"
    query.execute
    expect(query.query_result[0]["id"]).to eq("1000000")
  end

  it "should return the correct number of results required" do
    query = Query.new
    query.command = "SELECT id from customers LIMIT 5"
    query.execute
    expect(query.query_result.count).to eq(5)
  end


end
