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
      if widget_params.has_key?('query') and @widget.query_id != widget_params['query'].to_i
        @widget.query = Query.find(widget_params['query'])
        @widget.query.save
        @widget.save
        params.except!('variables')
      end
      if params.has_key?('variables')
        @widget.query.variables = params['variables']
        @widget.query.save
      end
      if @widget.update(widget_params.except('query', 'variables'))
        format.html { redirect_to dashboard_path, notice: 'Widget was successfully updated.' }
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
      format.html { redirect_to widgets_url, notice: 'Widget was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_widget
      @widget = Widget.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def widget_params
      params.require(:widget).permit(:name, :row, :column, :width, :height, :page, :type, :query)
    end
end
