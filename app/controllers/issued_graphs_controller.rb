class IssuedGraphsController < ApplicationController
  before_action :set_issued_graph, only: [:show, :edit, :update, :destroy]

  # GET /issued_graphs
  # GET /issued_graphs.json
  def index
    @issued_graphs = IssuedGraph.all
  end

  # GET /issued_graphs/1
  # GET /issued_graphs/1.json
  def show
  end

  # GET /issued_graphs/new
  def new
    @issued_graph = IssuedGraph.new
  end

  # GET /issued_graphs/1/edit
  def edit
  end

  # POST /issued_graphs
  # POST /issued_graphs.json
  def create
    @issued_graph = IssuedGraph.new(issued_graph_params)

    respond_to do |format|
      if @issued_graph.save
        format.html { redirect_to @issued_graph, notice: 'Issued graph was successfully created.' }
        format.json { render :show, status: :created, location: @issued_graph }
      else
        format.html { render :new }
        format.json { render json: @issued_graph.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /issued_graphs/1
  # PATCH/PUT /issued_graphs/1.json
  def update
    respond_to do |format|
      if @issued_graph.update(issued_graph_params)
        format.html { redirect_to @issued_graph, notice: 'Issued graph was successfully updated.' }
        format.json { render :show, status: :ok, location: @issued_graph }
      else
        format.html { render :edit }
        format.json { render json: @issued_graph.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issued_graphs/1
  # DELETE /issued_graphs/1.json
  def destroy
    @issued_graph.destroy
    respond_to do |format|
      format.html { redirect_to issued_graphs_url, notice: 'Issued graph was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issued_graph
      @issued_graph = IssuedGraph.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def issued_graph_params
      params[:issued_graph]
    end
end
