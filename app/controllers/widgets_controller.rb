class WidgetsController < ApplicationController
  before_action :set_widget, only: [:show, :edit, :update, :destroy]

  # GET /widgets
  # GET /widgets.json
  def index
    @widgets = Widget.all_descendants
  end

  # GET /widgets/1
  # GET /widgets/1.json
  def show
  end

  # GET /widgets/new
  def new
    @widget = Widget.new(widget_params)
  end

  # GET /widgets/1/edit
  def edit
  end

  # POST /widgets
  # POST /widgets.json
  def create
    @widget = Widget.new(widget_params)

    respond_to do |format|
      if @widget.save
        format.html { redirect_to dashboard_path, notice: 'Widget was successfully created.' }
        format.json { render :show, status: :created, location: @widget }
        format.js { render :layout => false }
      else
        format.html { render :new }
        format.json { render json: @widget.errors, status: :unprocessable_entity }
        format.js { render :layout => false }
      end
    end
  end

  # PATCH/PUT /widgets/1
  # PATCH/PUT /widgets/1.json
  def update
    respond_to do |format|
      if widget_params.has_key? 'query_id'
        @widget.query = Query.find(widget_params['query_id'])
        variables = params['widget']['variables'].deep_symbolize_keys
        variables[:providers] = variables[:providers].chomp(", ")
        display_variables = params['widget']['display_variables'].deep_symbolize_keys
        display_variables[:kpis] = display_variables[:kpis].chomp(", ")
        @widget.variables = variables
        @widget.display_variables = display_variables
        @widget.save
      elsif @widget.update(widget_params.except('query_id', 'variables', 'display_variables'))
        format.html { render nothing: true, notice: 'Widget was successfully updated.' }
        format.json { render :show, status: :ok, location: @widget }
      else
        format.html { render :edit }
        format.json { render json: @widget.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_page
    respond_to do |format|
      widget = Widget.find(params[:id])
      widget.page = params[:page]
      widget.save!
      format.html { render nothing: true }
    end
  end

  # DELETE /widgets/1
  # DELETE /widgets/1.json
  def destroy
    @widget.destroy
    respond_to do |format|
      format.html { redirect_to dashboard_path , notice: 'Widget was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_new_variables
    query_id = params[:id]
    if Query.find(query_id).complete_queries.empty?
      variables_array = Query.find(query_id).variables
      variables = variables_array.map { |var| [var,nil] }.to_h
    else
      variables = Query.find(query_id).complete_queries.order(last_executed: :desc).first.variables
    end
    respond_to do |format|
      format.html { render partial: 'widgets/variables', locals: {new_variables: variables} }
      format.json { render json: variables }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_widget
      @widget = Widget.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def widget_params
      params.require(:widget).permit(:name, :row, :column, :width, :height, :page, :type, :query_id)
    end
end
