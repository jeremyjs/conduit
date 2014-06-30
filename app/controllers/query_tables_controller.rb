class QueryTablesController < ApplicationController
  before_action :set_query_table, only: [:show, :edit, :update, :destroy]

  # GET /query_tables
  # GET /query_tables.json
  def index
    @query_tables = QueryTable.all
    @widgets = [{id: 1, name: "Name", data: ""}, {id: 2, name: "Name", data: ""}, {id: 3, name: "Name", data: ""}]
  end

  # GET /query_tables/1
  # GET /query_tables/1.json
  def show
    respond_to do |format|
      format.html
      mocked_json = [
        {
          provider: "provider",
          first_kpi: "value",
          second_kpi: "value",
          third_kpi: "value",
          nth_kpi: "value"
        },
        {
          provider: "provider",
          first_kpi: "value",
          second_kpi: "value",
          third_kpi: "value",
          nth_kpi: "value"
        },
        {
          provider: "provider",
          first_kpi: "value",
          second_kpi: "value",
          third_kpi: "value",
          nth_kpi: "value"
        },
        {
          provider: "provider",
          first_kpi: "value",
          second_kpi: "value",
          third_kpi: "value",
          nth_kpi: "value"
        },
        {
          provider: "provider",
          first_kpi: "value",
          second_kpi: "value",
          third_kpi: "value",
          nth_kpi: "value"
        }
      ]
      format.json { render json: mocked_json }
    end
  end

  # GET /query_tables/new
  def new
    @query_table = QueryTable.new
  end

  # GET /query_tables/1/edit
  def edit
  end

  # POST /query_tables
  # POST /query_tables.json
  def create
    @query_table = QueryTable.new(query_table_params)

    respond_to do |format|
      if @query_table.save
        format.html { redirect_to @query_table, notice: 'Query table was successfully created.' }
        format.json { render :show, status: :created, location: @query_table }
      else
        format.html { render :new }
        format.json { render json: @query_table.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /query_tables/1
  # PATCH/PUT /query_tables/1.json
  def update
    respond_to do |format|
      if @query_table.update(query_table_params)
        format.html { redirect_to @query_table, notice: 'Query table was successfully updated.' }
        format.json { render :show, status: :ok, location: @query_table }
      else
        format.html { render :edit }
        format.json { render json: @query_table.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /query_tables/1
  # DELETE /query_tables/1.json
  def destroy
    @query_table.destroy
    respond_to do |format|
      format.html { redirect_to query_tables_url, notice: 'Query table was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_query_table
      @query_table = QueryTable.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def query_table_params
      params.require(:query_table).permit(:query_id)
    end
end
