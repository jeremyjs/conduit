require 'rails_helper'

describe Widget do

  before :each do
    @query = FactoryGirl.create(:query)
    @new_query = FactoryGirl.create(:query , command: "SELECT id FROM customers LIMIT 10")
    @next_query = FactoryGirl.create(:query, command: "SELECT %{id} FROM customers LIMIT %{customers}")
    @w = FactoryGirl.create(:widget, query_id: @query.id)
    @new_widget = FactoryGirl.create(:widget, query_id: @next_query.id)
  end

  it "is valid only when it is associated with a query" do
    expect(@w).to be_valid
  end

  it "should set its a standard name if it is initialised without a name" do
    expect(@w.name).to eq("Untitled Widget")
  end

  it "should assign itself a default location of (1,1) if it is initialised without a row and column" do
    expect(@w.row).to eq(1)
    expect(@w.column).to eq(1)
  end

  it "should assign itself a width of 7 and a height of 5 if it is initialised without dimensions" do
    expect(@w.width).to eq(7)
    expect(@w.height).to eq(5)
  end

  it "should store its variables as a hash before saving" do
    expect(@w.variables.class).to eq(Hash)
  end

  it "should extract the variables from the command correctly" do
    expect(@new_widget.extract_variable_names).to eq(["id","customers"])
  end

  it "sets its variables to nil when no values are specified" do
    expect(@w.variables).to eq({customers: nil})
  end

  it "sets its variables to the values specified" do
    @w.variables = {customers: 6}
    @w.save
    expect(@w.variables).to eq({customers: 6})
  end

  it "does not add duplicate variables to the variable hash" do
    query = Query.new
    query.command = "SELECT id from customers LIMIT %{customers}  ORDER BY %{customers}"
    query.save
    w = Widget.new
    w.query_id = query.id
    w.save
    expect(w.variables).to eq({customers: nil})
  end

  it "should receive the has_changed callback before saving and should indicate a change in the query_id when the query_id has been set" do
    new_widget = Widget.new
    new_widget.query_id = @w.query_id
    expect(new_widget).to receive(:has_changed)
    expect(new_widget.query_id_changed?).to eq(true)
    new_widget.save
  end

  it "should execute the result and store in the result in query_result on saving" do
    @w.variables = {customers: 6}
    @w.save
    expect(@w.query_result.count).to eq(6)
  end

  it "should execute the result and store it in query_result as an array on saving" do
    @w.variables = {customers: 6}
    @w.save
    expect(@w.query_result.class).to eq(Array)
  end

  it "should not execute the query if the variables do not have any values" do
    expect(@w.query_result).to eq([])
  end

  it "should check for a change in variables in the before_save callback and should execute the query if all the variables have values" do
    expect(@w.query_result.count).to eq(0)
    @w.variables = {customers: 6}
    @w.save
    expect(@w.query_result.count).to eq(6)
  end

  it "should update the variables hash during the before_save callback" do
    expect(@w.variables).to eq({customers: nil})
    @w.variables = {customers: 9}
    @w.save
    expect(@w.variables).to eq({customers: 9})
  end

  it "should the update its variables hash when the command of its query has been changed" do
    expect(@w.variables).to eq({customers: nil})
    @w.query.command = "SELECT id from customers LIMIT 2"
    @w.save
    expect(@w.variables).to eq({})
  end

  it "should update the command associated with itself when the command of the query has been changed" do
    expect(@w.query.command).to eq("SELECT id FROM customers LIMIT %{customers}")
    @query.command = @new_query.command
    @query.save
    w = Widget.find_by(query_id: @query.id)
    expect(w.query.command).to eq("SELECT id FROM customers LIMIT 10")
  end

  it "should update its variables when the command of the query has been changed" do
    expect(@w.variables).to eq({customers: nil})
    @query.command = @new_query.command
    @query.save
    w = Widget.find_by(query_id: @query.id)
    expect(w.variables).to eq({})
  end

  it "should update its variables when it is assigned a different query" do
    expect(@w.variables).to eq({customers: nil})
    @w.query_id = @new_query.id
    @w.save
    expect(@w.variables).to eq({})
  end

  it "should update the command associated with itself when it is assigned to a different query" do
    expect(@w.query.command).to eq("SELECT id FROM customers LIMIT %{customers}")
    @w.query_id = @new_query.id
    @w.save
    expect(@w.query.command).to eq("SELECT id FROM customers LIMIT 10")
  end

  it "should update its query_result when it is assigned a new query" do
    expect(@w.query_result).to eq([])
    @w.query_id = @new_query.id
    @w.save
    expect(@w.query_result.count).to eq(10)
  end





end
