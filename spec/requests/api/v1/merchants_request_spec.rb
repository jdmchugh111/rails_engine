require 'rails_helper'

describe "Get all Merchants" do
  it "sends a list of merchants" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    get "/api/v1/merchants"

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchants.count).to eq(2)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)
      
      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to eq("merchant")
      
      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_a(Hash)

    end

    first_merchant = merchants.first
    expect(first_merchant[:attributes][:name]).to eq(merchant_1.name)
  end
end

describe "Get one Merchant" do
  it "can get one merchant by its id" do
    merchant_1 = create(:merchant)

    get "/api/v1/merchants/#{merchant_1.id}"
    
    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    
    expect(merchant).to be_a(Hash)

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_a(String)

    expect(merchant).to have_key(:type)
    expect(merchant[:type]).to eq("merchant")
    
    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes]).to be_a(Hash)
   
    expect(merchant[:attributes][:name]).to eq(merchant_1.name)
  end
end

describe "Get one Merchant sad path" do
  it "will gracefully handle if a book id doesn't exist" do
    get "/api/v1/merchants/1"

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:code]).to eq(404)
    expect(data[:errors].first[:title]).to eq("Couldn't find Merchant with 'id'=1")
  end
end