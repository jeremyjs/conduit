class ProvidersController < ApplicationController
  def index
    @providers = Provider.all
    respond_to do |format|
      format.html
      format.json { render json: @providers.to_json(only: [:name]) }
    end
  end
end
