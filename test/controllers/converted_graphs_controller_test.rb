require 'test_helper'

class ConvertedGraphsControllerTest < ActionController::TestCase
  setup do
    @converted_graph = converted_graphs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:converted_graphs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create converted_graph" do
    assert_difference('ConvertedGraph.count') do
      post :create, converted_graph: {  }
    end

    assert_redirected_to converted_graph_path(assigns(:converted_graph))
  end

  test "should show converted_graph" do
    get :show, id: @converted_graph
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @converted_graph
    assert_response :success
  end

  test "should update converted_graph" do
    patch :update, id: @converted_graph, converted_graph: {  }
    assert_redirected_to converted_graph_path(assigns(:converted_graph))
  end

  test "should destroy converted_graph" do
    assert_difference('ConvertedGraph.count', -1) do
      delete :destroy, id: @converted_graph
    end

    assert_redirected_to converted_graphs_path
  end
end
