require 'rails_helper'

describe "Create an Item" do
  it "can create a new item record" do
    merchant_1 = create(:merchant)
    item_params = ({
                    name: 'Cowboy Hat',
                    description: 'It looks cool',
                    unit_price: 40.00,
                    merchant_id: merchant_1.id
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end
end

describe "Edit an Item" do
  it "can update an item" do
    merchant = create(:merchant)
    id = create(:item, merchant: merchant).id
    previous_name = Item.last.name
    item_params = { name: "Tam" }
    headers = {"CONTENT_TYPE" => "application/json"}
  
    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find(id)
  
    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("Tam")
  end
end

describe "Delete an Item" do
  it "can delete an item" do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)
  
    expect(Item.count).to eq(1)
  
    delete "/api/v1/items/#{item.id}"
  
    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end

describe "Get Merchant Data for given Item" do
  it "can get single merchant if given item id" do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)

    get "/api/v1/items/#{item.id}/merchant"

    merchant_hash = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    
    expect(merchant_hash).to be_a(Hash)

    expect(merchant_hash).to have_key(:id)
    expect(merchant_hash[:id]).to be_a(String)
    
    expect(merchant_hash).to have_key(:attributes)
    expect(merchant_hash[:attributes]).to be_a(Hash)
    expect(merchant_hash[:attributes][:name]).to be_a(String)
  end

  it "if item id is not given (get all items)" do
    merchant = create(:merchant)
    item1 = create(:item, merchant: merchant)
    item2 = create(:item, merchant: merchant)

    get "/api/v1/items"
    all_items = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(all_items.count).to eq(2)
  end
end


describe "sad path" do
  it "must have all attributes to create a new item" do
    merchant_1 = create(:merchant)
    item_params = ({
                    name: 'Cowboy Hat',
                    description: 'It looks cool',
                    merchant_id: merchant_1.id
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    expect(response).to_not be_successful
  end

  it "must not pass an invalid merchant_id when updating an item" do
    merchant = create(:merchant)
    id = create(:item, merchant: merchant).id
    headers = {"CONTENT_TYPE" => "application/json"}
  
    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({merchant_id: 999999})
    
    expect(response).to_not be_successful
  end
end