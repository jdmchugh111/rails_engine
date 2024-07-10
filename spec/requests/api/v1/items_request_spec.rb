require 'rails_helper'

describe "Get all Items" do
  it "sends a list of items" do
    merchant_1 = create(:merchant)
    item_1 = create(:item, merchant_id: merchant_1.id)
    item_2 = create(:item, merchant_id: merchant_1.id)

    get "/api/v1/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(items.count).to eq(2)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)
      
      expect(item).to have_key(:type)
      expect(item[:type]).to eq("item")
      
      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_a(Hash)
    end

    first_item = items.first

    expect(first_item[:attributes][:name]).to eq(item_1.name)
    expect(first_item[:attributes][:description]).to eq(item_1.description)
    expect(first_item[:attributes][:unit_price]).to eq(item_1.unit_price)
    expect(first_item[:attributes][:unit_price]).to be_a(Float)
    expect(first_item[:attributes][:merchant_id]).to eq(item_1.merchant_id)
  end
end

describe "Get one Item" do
  it "can get one item by its id" do
    merchant_1 = create(:merchant)
    item_1 = create(:item, merchant_id: merchant_1.id)

    get "/api/v1/items/#{item_1.id}/"
    
    item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    
    expect(item).to be_a(Hash)

    expect(item).to have_key(:id)
    expect(item[:id]).to be_a(String)

    expect(item).to have_key(:type)
    expect(item[:type]).to eq("item")
    
    expect(item).to have_key(:attributes)
    expect(item[:attributes]).to be_a(Hash)
   
    expect(item[:attributes][:name]).to be_a(String)
    expect(item[:attributes][:name]).to eq(item_1.name)
    expect(item[:attributes][:description]).to eq(item_1.description)
    expect(item[:attributes][:unit_price]).to eq(item_1.unit_price)
    expect(item[:attributes][:merchant_id]).to eq(item_1.merchant_id)
  end
end