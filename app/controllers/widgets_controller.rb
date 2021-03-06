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
    @widget.user_id = current_user.id
    @widget.save
    respond_to do |format|
      if @widget.save
        format.html { redirect_to dashboard_path, notice: 'Widget was successfully created.' }
        format.json { render :show, status: :created, location: @widget }
        format.js { render :layout => false }
      else
        format.html { redirect_to widgets_path}
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
        variables = params['widget']['variables']
        unless variables.nil?
          variables = params['widget']['variables'].deep_symbolize_keys
        end

        display_variables = params['widget']['display_variables']
        unless display_variables.nil?
          display_variables = params['widget']['display_variables'].deep_symbolize_keys
          display_variables[:providers] = formatted_providers(display_variables[:providers])
          display_variables[:kpis] = display_variables[:kpis]
        end

        @widget.variables = variables
        @widget.display_variables = display_variables
        @widget.save
      end
      if @widget.update(widget_params.except('query_id', 'user', 'variables', 'display_variables'))
        email = params['widget']['user']
        if not email.empty?
          user = User.find_by(email: email)
          copy = @widget.dup
          copy.user = user
          copy.save
        end
        format.html { render nothing: true, notice: 'Widget was successfully updated.' }
        format.json { render :show, status: :ok, location: @widget }
      else
        format.html { render :edit }
        format.json { render json: @widget.errors, status: :unprocessable_entity }
      end
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
      variables = Query.find(query_id).complete_queries.order(last_executed: :desc).first.get_required_variables
    end
    respond_to do |format|
      format.html { render partial: 'widgets/variables', locals: {new_variables: variables} }
      format.json { render json: variables }
    end
  end

  private
    def formatted_providers(providers)
      if providers.tr(" \n\t", "") == "*"
        Provider.all_providers(@widget.brand)
      else
        providers.chomp(", ")
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_widget
      @widget = Widget.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def widget_params
      params.require(:widget).permit(:name, :row, :column, :width, :height, :type, :query_id, {variables: [:start_time, :end_time, :providers, :brand_id]}, {display_variables: [kpis: []]})
    end
end
