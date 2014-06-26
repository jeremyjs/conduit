class ConvertedGraphsController < ApplicationController
  before_action :set_converted_graph, only: [:show, :edit, :update, :destroy]

  # GET /converted_graphs
  # GET /converted_graphs.json
  def index
    @converted_graphs = ConvertedGraph.all
  end

  # GET /converted_graphs/1
  # GET /converted_graphs/1.json
  def show
  end

  # GET /converted_graphs/new
  def new
    @converted_graph = ConvertedGraph.new
  end

  # GET /converted_graphs/1/edit
  def edit
  end

  # POST /converted_graphs
  # POST /converted_graphs.json
  def create
    @converted_graph = ConvertedGraph.new(converted_graph_params)

    respond_to do |format|
      if @converted_graph.save
        format.html { redirect_to @converted_graph, notice: 'Converted graph was successfully created.' }
        format.json { render :show, status: :created, location: @converted_graph }
      else
        format.html { render :new }
        format.json { render json: @converted_graph.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /converted_graphs/1
  # PATCH/PUT /converted_graphs/1.json
  def update
    respond_to do |format|
      if @converted_graph.update(converted_graph_params)
        format.html { redirect_to @converted_graph, notice: 'Converted graph was successfully updated.' }
        format.json { render :show, status: :ok, location: @converted_graph }
      else
        format.html { render :edit }
        format.json { render json: @converted_graph.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /converted_graphs/1
  # DELETE /converted_graphs/1.json
  def destroy
    @converted_graph.destroy
    respond_to do |format|
      format.html { redirect_to converted_graphs_url, notice: 'Converted graph was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_converted_graph
      @converted_graph = ConvertedGraph.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def converted_graph_params
      params[:converted_graph]
    end
end
