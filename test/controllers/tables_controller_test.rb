require 'test_helper'

class QueryTablesControllerTest < ActionController::TestCase
  setup do
    @query_table = query_tables(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:query_tables)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create query_table" do
    assert_difference('QueryTable.count') do
      post :create, query_table: { query_id: @query_table.query_id }
    end

    assert_redirected_to query_table_path(assigns(:query_table))
  end

  test "should show query_table" do
    get :show, id: @query_table
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @query_table
    assert_response :success
  end

  test "should update query_table" do
    patch :update, id: @query_table, query_table: { query_id: @query_table.query_id }
    assert_redirected_to query_table_path(assigns(:query_table))
  end

  test "should destroy query_table" do
    assert_difference('QueryTable.count', -1) do
      delete :destroy, id: @query_table
    end

    assert_redirected_to query_tables_path
  end
end
