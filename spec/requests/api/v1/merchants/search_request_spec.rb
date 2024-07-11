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

describe 
end