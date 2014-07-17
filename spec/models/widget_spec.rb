require 'rails_helper'

describe Widget do

  before :each do
    @query = Query.new
    @query.command = "SELECT id from customers LIMIT %{customers}"
    @query.save
  end

  it "is valid only when it is associated with a query" do
    w = Widget.new
    w.query_id = @query.id
    expect(w).to be_valid
  end

  it "sets its variables to nil when no values are specified" do
    w = Widget.new
    w.query_id = @query.id
    w.save
    expect(w.variables).to eq({customers: nil})
  end

  it "sets its variables to the values specified" do
    w = Widget.new
    w.query_id = @query.id
    w.variables = {customers: 6}
    w.save
    expect(w.variables).to eq({customers: 6})
  end

  it "should receive the has_changed callback before saving and should indicate a change in the query_id" do
    w = Widget.new
    w.query_id = @query.id
    expect(w).to receive(:has_changed)
    expect(w.query_id_changed?).to eq(true)
    w.save
  end

  it "should execute the result and store in the result in query_result on saving" do
    w = Widget.new
    w.query_id = @query.id
    w.variables = {customers: 6}
    w.save
    expect(w.query_result.count).to eq(6)
  end

  it "should execute the result and store it as an array on saving" do
    w = Widget.new
    w.query_id = @query.id
    w.variables = {customers: 6}
    w.save
    expect(w.query_result.class).to eq(Array)
  end

  it "should not execute the query if the variables do not have any values" do
    w = Widget.new
    w.query_id = @query.id
    w.save
    expect(w.query_result).to eq([])
  end

  it "should check for a change in variables in the before_save callback and should execute the query if all the variables have values" do
    w = Widget.new
    w.query_id = @query.id
    w.save
    expect(w.query_result.count).to eq(0)
    w.variables = {customers: 6}
    w.save
    expect(w.query_result.count).to eq(6)
  end

  it "should update the variables hash during the before_save callback" do
    w = Widget.new
    w.query_id = @query.id
    w.save
    expect(w.variables).to eq({customers: nil})
    w.variables = {customers: 9}
    w.save
    expect(w.variables).to eq({customers: 9})
  end

end
