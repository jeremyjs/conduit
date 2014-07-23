require 'rails_helper'

describe Widget do

  before :each do
    @query = FactoryGirl.create(:query)
    @new_query = FactoryGirl.create(:query , command: "SELECT id FROM customers LIMIT 10")
    @next_query = FactoryGirl.create(:query, command: "SELECT %{id} FROM customers LIMIT %{customers}")
    @w = FactoryGirl.create(:widget, query_id: @query.id)
    @new_widget = FactoryGirl.create(:widget, query_id: @next_query.id)
    @new_query_widget = FactoryGirl.create(:widget , query_id: @new_query.id)
    @complete_query_first = CompleteQuery.find_by(query_id: @new_query.id)
  end

  context 'when a widget is created' do

    let(:new_widget) {FactoryGirl.create(:widget)}

    it "is valid only when it is associated with a query" do
      expect(new_widget).to be_valid
    end

    it "should set a query whose id is 1" do
      expect(new_widget.query_id).to eq(1)
    end

    it "should set a standard name" do
      expect(new_widget.name).to eq("Untitled Widget")
    end

    it "should set a location" do
      expect(new_widget.row).to eq(1)
      expect(new_widget.column).to eq(1)
    end

    it "should set its dimensions" do
      expect(new_widget.width).to eq(7)
      expect(new_widget.height).to eq(5)
    end

    it "should store its variables in a hash" do
      expect(new_widget.variables.class).to eq(Hash)
    end

    it "should store its query result in an array" do
      expect(new_widget.query_result.class).to eq(Array)
    end

  end

  context '#widget variables' do

    let(:new_query) {FactoryGirl.create(:query , command: "SELECT id FROM customers LIMIT %{number}")}
    let(:new_widget) {FactoryGirl.create(:widget , query_id: new_query.id)}
    let(:alternate_query) {FactoryGirl.create(:query, command: "SELECT id FROM customers LIMIT 5")}

    it "should extract the variables from the command" do
      expect(new_widget.extract_variable_names).to eq(["number"])
    end

    it "sets its variables to nil when no values are specified" do
      expect(new_widget.variables).to eq({number: nil})
    end

    it "sets its variables to the values specified" do
      new_widget.variables = {number: 6}
      new_widget.save
      expect(new_widget.variables).to eq({number: 6})
    end

    it "should the update its variables hash when the command of its query has been changed" do
      new_query.command = "SELECT id from customers LIMIT 2"
      new_query.save
      expect(new_widget.variables).to eq({})
    end

    it "should not execute the query if the variables do not have any values" do
      expect(new_widget.query_result).to eq([])
    end

    it "should check for a change in variables in the before_save callback and should execute the query if all the variables have values" do
      new_widget.variables = {number: 6}
      new_widget.save
      expect(new_widget.query_result.count).to eq(6)
    end

    it "should update its variables when it is assigned a different query" do
      new_widget.query_id = alternate_query.id
      new_widget.save
      expect(new_widget.variables).to eq({})
    end

  end

  context 'before save callbacks' do

    let(:new_query) {FactoryGirl.create(:query , command: "SELECT id FROM customers LIMIT %{number}")}
    let(:new_widget) {FactoryGirl.create(:widget , query_id: new_query.id)}
    let(:alternate_query) {FactoryGirl.create(:query, command: "SELECT id FROM customers LIMIT 5")}

    it "should receive the update_widget callback before save when its query has been changed" do
      new_widget.query_id = alternate_query.id
      expect(new_widget).to receive(:update_widget)
      expect(new_widget.query_id_changed?).to eq(true)
      new_widget.save
    end

    it "should receive the update_widget callback before save when its variables have been changed" do
      new_widget.variables = {number: 6}
      expect(new_widget).to receive(:update_widget)
      expect(new_widget.variables_changed?).to eq(true)
      new_widget.save
    end

  end

  context '#widget has_changed?' do

    let(:new_query) {FactoryGirl.create(:query , command: "SELECT id FROM customers LIMIT %{number}")}
    let(:new_widget) {FactoryGirl.create(:widget , query_id: new_query.id)}
    let(:alternate_query) {FactoryGirl.create(:query, command: "SELECT id FROM customers LIMIT 5")}

    it "should indicate a change in its query before save when its query has been changed" do
      new_widget.query_id = alternate_query.id
      expect(new_widget.query_id_changed?).to eq(true)
      new_widget.save
    end

    it "should indicate a change in its variables before save when its variables have been changed" do
      new_widget.variables = {number: 6}
      expect(new_widget.variables_changed?).to eq(true)
      new_widget.save
    end

  end

  context '#widget query_result' do

  end

  it "should execute the result and store in the result in query_result on saving" do
    @w.variables = {customers: 6}
    @w.save
    expect(@w.query_result.count).to eq(6)
  end

  it "should update its query_result when it is assigned a new query" do
    expect(@w.query_result).to eq([])
    @w.query_id = @new_query.id
    @w.save
    expect(@w.query_result.count).to eq(10)
  end

  it "should use the cached result to set the query result of widget parameters which match that of the completed query" do
    new_widget = FactoryGirl.create(:widget , query_id: @new_query.id)
    expect(new_widget.variables).to eq(@complete_query_first.variables)
    expect(new_widget.last_executed).to eq(@complete_query_first.last_executed)
  end

  it "should execute the query and update the cached result when completed query is not fresh" do
    @complete_query_first.last_executed = "2014-07-22 00:00:00"
    @complete_query_first.save
    new_widget = FactoryGirl.create(:widget, query_id: @new_query.id)
    complete_query = CompleteQuery.find_by(query_id: @new_query.id)
    expect(complete_query.last_executed).to eq(new_widget.last_executed)
    expect(complete_query.query_result).to eq(new_widget.query_result)
  end

  context 'test' do

    let(:first_widget) {FactoryGirl.create(:widget , query_id: 3 , variables: {start_time: "2014-06-15 00:00:00" , end_time: "2014-06-17 00:00:00" , providers: "'t3uk', 'eloansuk'"})}
    let(:complete_query) {CompleteQuery.last}
    let(:second_widget) {create_second_widget}


    def create_second_widget
      second_widget = FactoryGirl.create(:widget, query_id: first_widget.query_id)
      second_widget
    end

    it "should do something" do
     second_widget.variables = {start_time: "2014-06-16 00:00:00" , end_time: "2014-06-16 23:59:59" , providers: "'t3uk'"}
     expect(second_widget).to receive(:use_cached_result_with_subset).with(complete_query)
     second_widget.save
    end

    it "should do something" do
     second_widget.variables = {start_time: "2014-06-16 00:00:00" , end_time: "2014-06-16 23:59:59" , providers: "'t3uk', 'eloansuk'"}
     expect(second_widget).to receive(:use_cached_result_with_subset).with(complete_query)
     second_widget.save
    end

    it "should do something" do
     complete_query.last_executed = "2014-07-15 00:00:00"
     complete_query.save
     second_widget.variables = {start_time: "2014-06-16 00:00:00" , end_time: "2014-06-16 23:59:59" , providers: "'t3uk'"}
     expect(second_widget).to_not receive(:use_cached_result_with_subset).with(complete_query)
     second_widget.save
    end

    it "should not call callback" do
     second_widget.variables = {start_time: "2014-06-16 00:00:00" , end_time: "2014-06-16 23:59:59" , providers: "'milarco'"}
     expect(second_widget).to_not receive(:use_cached_result_with_subset).with(complete_query)
     second_widget.save
    end

    it "should " do
     second_widget.variables = {start_time: "2014-06-16 00:00:00" , end_time: "2014-06-18 23:59:59" , providers: "'milarco'"}
     expect(second_widget).to_not receive(:use_cached_result_with_subset).with(complete_query)
     second_widget.save
    end

    it "should" do
     second_widget.variables = {start_time: "2014-06-16 00:00:00"  , providers: "'milarco'"}
     expect(second_widget).to_not receive(:use_cached_result_with_subset).with(complete_query)
     second_widget.save
    end

  end

end
