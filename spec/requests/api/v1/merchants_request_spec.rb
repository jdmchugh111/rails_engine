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
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"
    
    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    
    expect(merchant).to be_a(Hash)

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_a(String)

    expect(merchant).to have_key(:type)
    expect(merchant[:type]).to eq("merchant")
    
    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes]).to be_a(Hash)
   
    expect(merchant[:attributes][:name]).to be_a(String)
  end
end

describe "Find one Merchant based on search criteria" do
  it "should return the first object in the database in case-insensitive alphabetical order if multiple matches are found" do
    merchant_1 = Merchant.create(name: "Turing")
    merchant_2 = Merchant.create(name: "Ring World")

    get "/api/v1/merchants/find?name=ring"

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    
    # expect(merchant.count).to eq(1)

    expect(response).to be_successful
    
    expect(merchant).to be_a(Hash)

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_a(String)

    expect(merchant).to have_key(:type)
    expect(merchant[:type]).to eq("merchant")
    
    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes]).to be_a(Hash)
   
    expect(merchant[:attributes][:name]).to be_a(String)
    expect(merchant[:attributes][:name]).to eq("Ring World")
  end
end