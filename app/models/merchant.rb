class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :items
  has_many :customers, through: :invoices 
  has_many :transactions, through: :invoices 

  def self.search(search_params)
    where("name ILIKE ?", "%#{search_params}%").order(name: :asc).first
  end
end
