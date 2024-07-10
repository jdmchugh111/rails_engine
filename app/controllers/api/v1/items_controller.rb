class Api::V1::ItemsController < ApplicationController
  def index
    if params[:merchant_id].present?
      render json: ItemSerializer.new(Item.merchant_items(params[:merchant_id]))
    else  
      render json: ItemSerializer.new(Item.all)
    end
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end
end