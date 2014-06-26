class ImportedGraphsController < ApplicationController
  before_action :set_imported_graph, only: [:show, :edit, :update, :destroy]

  # GET /imported_graphs
  # GET /imported_graphs.json
  def index
    @imported_graphs = ImportedGraph.all
  end

  # GET /imported_graphs/1
  # GET /imported_graphs/1.json
  def show
  end

  # GET /imported_graphs/new
  def new
    @imported_graph = ImportedGraph.new
  end

  # GET /imported_graphs/1/edit
  def edit
  end

  # POST /imported_graphs
  # POST /imported_graphs.json
  def create
    @imported_graph = ImportedGraph.new(imported_graph_params)

    respond_to do |format|
      if @imported_graph.save
        format.html { redirect_to @imported_graph, notice: 'Imported graph was successfully created.' }
        format.json { render :show, status: :created, location: @imported_graph }
      else
        format.html { render :new }
        format.json { render json: @imported_graph.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /imported_graphs/1
  # PATCH/PUT /imported_graphs/1.json
  def update
    respond_to do |format|
      if @imported_graph.update(imported_graph_params)
        format.html { redirect_to @imported_graph, notice: 'Imported graph was successfully updated.' }
        format.json { render :show, status: :ok, location: @imported_graph }
      else
        format.html { render :edit }
        format.json { render json: @imported_graph.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /imported_graphs/1
  # DELETE /imported_graphs/1.json
  def destroy
    @imported_graph.destroy
    respond_to do |format|
      format.html { redirect_to imported_graphs_url, notice: 'Imported graph was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_imported_graph
      @imported_graph = ImportedGraph.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def imported_graph_params
      params[:imported_graph]
    end
end
