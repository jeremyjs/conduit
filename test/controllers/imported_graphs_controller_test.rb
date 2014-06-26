require 'test_helper'

class ImportedGraphsControllerTest < ActionController::TestCase
  setup do
    @imported_graph = imported_graphs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:imported_graphs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create imported_graph" do
    assert_difference('ImportedGraph.count') do
      post :create, imported_graph: {  }
    end

    assert_redirected_to imported_graph_path(assigns(:imported_graph))
  end

  test "should show imported_graph" do
    get :show, id: @imported_graph
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @imported_graph
    assert_response :success
  end

  test "should update imported_graph" do
    patch :update, id: @imported_graph, imported_graph: {  }
    assert_redirected_to imported_graph_path(assigns(:imported_graph))
  end

  test "should destroy imported_graph" do
    assert_difference('ImportedGraph.count', -1) do
      delete :destroy, id: @imported_graph
    end

    assert_redirected_to imported_graphs_path
  end
end
