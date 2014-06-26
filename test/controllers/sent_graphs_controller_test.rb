require 'test_helper'

class SentGraphsControllerTest < ActionController::TestCase
  setup do
    @sent_graph = sent_graphs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sent_graphs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sent_graph" do
    assert_difference('SentGraph.count') do
      post :create, sent_graph: {  }
    end

    assert_redirected_to sent_graph_path(assigns(:sent_graph))
  end

  test "should show sent_graph" do
    get :show, id: @sent_graph
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sent_graph
    assert_response :success
  end

  test "should update sent_graph" do
    patch :update, id: @sent_graph, sent_graph: {  }
    assert_redirected_to sent_graph_path(assigns(:sent_graph))
  end

  test "should destroy sent_graph" do
    assert_difference('SentGraph.count', -1) do
      delete :destroy, id: @sent_graph
    end

    assert_redirected_to sent_graphs_path
  end
end
