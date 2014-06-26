require 'test_helper'

class IssuedGraphsControllerTest < ActionController::TestCase
  setup do
    @issued_graph = issued_graphs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:issued_graphs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create issued_graph" do
    assert_difference('IssuedGraph.count') do
      post :create, issued_graph: {  }
    end

    assert_redirected_to issued_graph_path(assigns(:issued_graph))
  end

  test "should show issued_graph" do
    get :show, id: @issued_graph
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @issued_graph
    assert_response :success
  end

  test "should update issued_graph" do
    patch :update, id: @issued_graph, issued_graph: {  }
    assert_redirected_to issued_graph_path(assigns(:issued_graph))
  end

  test "should destroy issued_graph" do
    assert_difference('IssuedGraph.count', -1) do
      delete :destroy, id: @issued_graph
    end

    assert_redirected_to issued_graphs_path
  end
end
