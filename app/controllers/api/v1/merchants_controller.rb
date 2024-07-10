class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def find
    render json: MerchantSerializer.new(Merchant.search(params[:name]))
  end
  #move this to a SearchController #show
end