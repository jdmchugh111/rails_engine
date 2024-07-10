class Api::V1::ItemsController < ApplicationController


  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    if params[:item_id].present?
      item = Item.find(params[:item_id])
      render json: MerchantSerializer.new(Merchant.find(item.merchant_id))
    elsif params[:merchant_id].present?
      render json: ItemSerializer.new(Item.merchant_items(params[:merchant_id]))
    else  
      render json: ItemSerializer.new(Item.all)
    end
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end


  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: :created
    else
      render json: ErrorSerializer.new(ErrorMessage.new("all attributes must be passed in params", 400)).serialize_json, status: :bad_request
    end
  end

  def update
    item = Item.find(params[:id])
    if params[:merchant_id].present? && !Merchant.find(params[:merchant_id]).present?
    elsif item.update(item_params) 
      render json: ItemSerializer.new(item), status: :created
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
  end


private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end

end