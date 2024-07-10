class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates_presence_of :name,
                        :description,
                        :unit_price

  def self.merchant_items(merchant_id)
    Merchant.find(merchant_id).items
  end
end
