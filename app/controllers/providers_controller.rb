class ProvidersController < ApplicationController
  def index
    @providers = Provider.all
    respond_to do |format|
      format.html
      format.json { render json: @providers.to_json(only: [:name]) }
    end
  end

  def providers_by_brand
    brand_id = params[:brand]
    @providers = Provider.where(brand_id: brand_id)
    respond_to do |format|
      format.html
      format.json { render json: @providers.to_json(only: [:name]) }
    end
  end
end
