require 'rails_helper'

describe Query do

  before :each do
    @query = FactoryGirl.create(:query, command: "SELECT id FROM customers LIMIT 5")
    @first_widget = FactoryGirl.create(:widget, query_id: @query.id)
  end

  it "is valid with valid attributes" do
    expect(@query).to be_valid
  end

  it "should receive the has_changed callback before saving and should indicate a change in its command" do
    new_query = Query.new
    new_query.command = "SELECT id FROM customers LIMIT 5 ORDER BY id"
    expect(new_query).to receive(:has_changed)
    expect(new_query.command_changed?).to eq(true)
    new_query.save
    expect(new_query.command_changed?).to eq(false)
  end

  it "should be able to execute any command given"  do
    final_result = Query.execute(@query.command)
    expect(final_result.count).to eq(5)
  end

  it "should execute any command given to it and return the result in an array" do
    final_result = Query.execute(@query.command)
    expect(final_result.class).to eq(Array)
  end

  it "should change the command of the widgets associated with it when its command has been changed" do
    @query.command = "SELECT id from %{choose}"
    @query.save
    @first_widget.reload
    expect(@first_widget.query.command).to eq("SELECT id from %{choose}")
  end


end
