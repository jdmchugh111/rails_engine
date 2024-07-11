class Api::V1::Merchants::SearchController < ApplicationController
  def show
    if Merchant.search(params[:name]) == nil
      render json: { 
        "data": {},
        "error": "no matches"
      }
    else 
      render json: MerchantSerializer.new(Merchant.search(params[:name]))
    end
  end
end