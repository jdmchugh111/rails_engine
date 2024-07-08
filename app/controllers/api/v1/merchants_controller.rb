class Api::V1::MerchantsController < ApplicationController
  def index
    render json: {data: Merchant.all}
    #needs serialization 
  end
end