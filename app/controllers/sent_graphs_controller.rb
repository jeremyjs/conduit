class SentGraphsController < ApplicationController
  before_action :set_sent_graph, only: [:show, :edit, :update, :destroy]

  # GET /sent_graphs
  # GET /sent_graphs.json
  def index
    @sent_graphs = SentGraph.all
  end

  # GET /sent_graphs/1
  # GET /sent_graphs/1.json
  def show
  end

  # GET /sent_graphs/new
  def new
    @sent_graph = SentGraph.new
  end

  # GET /sent_graphs/1/edit
  def edit
  end

  # POST /sent_graphs
  # POST /sent_graphs.json
  def create
    @sent_graph = SentGraph.new(sent_graph_params)

    respond_to do |format|
      if @sent_graph.save
        format.html { redirect_to @sent_graph, notice: 'Sent graph was successfully created.' }
        format.json { render :show, status: :created, location: @sent_graph }
      else
        format.html { render :new }
        format.json { render json: @sent_graph.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sent_graphs/1
  # PATCH/PUT /sent_graphs/1.json
  def update
    respond_to do |format|
      if @sent_graph.update(sent_graph_params)
        format.html { redirect_to @sent_graph, notice: 'Sent graph was successfully updated.' }
        format.json { render :show, status: :ok, location: @sent_graph }
      else
        format.html { render :edit }
        format.json { render json: @sent_graph.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sent_graphs/1
  # DELETE /sent_graphs/1.json
  def destroy
    @sent_graph.destroy
    respond_to do |format|
      format.html { redirect_to sent_graphs_url, notice: 'Sent graph was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sent_graph
      @sent_graph = SentGraph.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sent_graph_params
      params[:sent_graph]
    end
end
