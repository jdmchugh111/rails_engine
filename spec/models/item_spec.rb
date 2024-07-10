require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :merchant_id }
  end
  describe "relationships" do
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should belong_to :merchant }
  end

  describe "name_search" do
    it "can search by name - partial and case insensitive" do
      merchant_1 = create(:merchant)
      item_1 = Item.create!(name: "Cowboy Hat", description: "looks cool", unit_price: 45.99, merchant_id: merchant_1.id)
      expect(Item.name_search("oWB")).to eq([item_1])
    end
  end

  describe "price_search" do
    it "can search by min and max" do
      merchant_1 = create(:merchant)
      item_1 = Item.create!(name: "Cowboy Hat", description: "looks cool", unit_price: 45.99, merchant_id: merchant_1.id)
      item_2 = Item.create!(name: "Bowler Hat", description: "looks cool", unit_price: 40.99, merchant_id: merchant_1.id)
      item_3 = Item.create!(name: "Beret", description: "looks cool", unit_price: 25.99, merchant_id: merchant_1.id)
      expect(Item.price_search("30.00", "42.00")).to eq([item_2])
    end

    it "can search by min, no max" do
      merchant_1 = create(:merchant)
      item_1 = Item.create!(name: "Cowboy Hat", description: "looks cool", unit_price: 45.99, merchant_id: merchant_1.id)
      item_2 = Item.create!(name: "Bowler Hat", description: "looks cool", unit_price: 40.99, merchant_id: merchant_1.id)
      item_3 = Item.create!(name: "Beret", description: "looks cool", unit_price: 25.99, merchant_id: merchant_1.id)
      expect(Item.price_search("30.00", nil)).to eq([item_2, item_1])
    end

    it "can search by max, no min" do
      merchant_1 = create(:merchant)
      item_1 = Item.create!(name: "Cowboy Hat", description: "looks cool", unit_price: 45.99, merchant_id: merchant_1.id)
      item_2 = Item.create!(name: "Bowler Hat", description: "looks cool", unit_price: 40.99, merchant_id: merchant_1.id)
      item_3 = Item.create!(name: "Beret", description: "looks cool", unit_price: 25.99, merchant_id: merchant_1.id)
      expect(Item.price_search(nil, "45.00")).to eq([item_3, item_2])
    end
  end
end
