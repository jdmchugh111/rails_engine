class Api::V1::Items::SearchController < ApplicationController
  def index
    if params[:name].present? && (params[:min_price].present? || params[:max_price].present?)
      render json: ErrorSerializer.new(ErrorMessage.new("can only pass name OR min/max param", 400)).serialize_json, status: :bad_request
    elsif params[:min_price].present? && params[:min_price].to_f < 0
      render json: ErrorSerializer.new(ErrorMessage.new("min_by cannot be negative", 400)).serialize_json, status: :bad_request
    elsif params[:max_price].present? && params[:max_price].to_f < 0
      render json: ErrorSerializer.new(ErrorMessage.new("max_by cannot be negative", 400)).serialize_json, status: :bad_request
    elsif params[:name].present?
      render json: ItemSerializer.new(Item.name_search(params[:name]))
    elsif params[:min_price].present? || params[:max_price].present?
      render json: ItemSerializer.new(Item.price_search(params[:min_price], params[:max_price]))
    end
  end
end