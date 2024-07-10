require 'rails_helper'

describe "Search" do
  it "can search for an item by name - case and partial insensitive" do
    merchant_1 = create(:merchant)
    item_1 = Item.create!(name: "Cowboy Hat", description: "looks cool", unit_price: 45.99, merchant_id: merchant_1.id)
    
    get "/api/v1/items/find_all?name=oWb"

    json = JSON.parse(response.body, symbolize_names: true)[:data]
    
    expect(json.first[:attributes][:name]).to eq("Cowboy Hat")
  end

  it "can search for an item by min and max" do
    merchant_1 = create(:merchant)
    item_1 = Item.create!(name: "Cowboy Hat", description: "looks cool", unit_price: 45.99, merchant_id: merchant_1.id)
    item_2 = Item.create!(name: "Bowler Hat", description: "looks cool", unit_price: 40.99, merchant_id: merchant_1.id)
    item_3 = Item.create!(name: "Beret", description: "looks cool", unit_price: 25.99, merchant_id: merchant_1.id)

    get "/api/v1/items/find_all?min_price=30.00&max_price=42.00"

    json = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(json.first[:attributes][:name]).to eq("Bowler Hat")
  end
end

describe "sad path" do
  it "can only pass name OR price parameters" do
    merchant_1 = create(:merchant)
    item_1 = Item.create!(name: "Cowboy Hat", description: "looks cool", unit_price: 45.99, merchant_id: merchant_1.id)
    item_2 = Item.create!(name: "Bowler Hat", description: "looks cool", unit_price: 40.99, merchant_id: merchant_1.id)
    item_3 = Item.create!(name: "Beret", description: "looks cool", unit_price: 25.99, merchant_id: merchant_1.id)

    get "/api/v1/items/find_all?min_price=30.00&max_price=42.00&name=oWb"

    expect(response).to_not be_successful
  end

  it "can pass a negative number for min or max price" do
    merchant_1 = create(:merchant)
    item_1 = Item.create!(name: "Cowboy Hat", description: "looks cool", unit_price: 45.99, merchant_id: merchant_1.id)
    item_2 = Item.create!(name: "Bowler Hat", description: "looks cool", unit_price: 40.99, merchant_id: merchant_1.id)
    item_3 = Item.create!(name: "Beret", description: "looks cool", unit_price: 25.99, merchant_id: merchant_1.id)

    get "/api/v1/items/find_all?min_price=-30.00"
    expect(response).to_not be_successful

    get "/api/v1/items/find_all?max_price=-30.00"
    expect(response).to_not be_successful
  end
end