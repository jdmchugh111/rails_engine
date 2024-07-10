class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates_presence_of :name,
                        :description,
                        :unit_price,
                        :merchant_id

  def self.name_search(search_params)
    where("name ILIKE ?", "%#{search_params}%").sort_by {|item| item.name}
  end

  def self.price_search(min, max)
    if min != nil && max != nil
      where("unit_price > #{min}").where("unit_price < #{max}").sort_by {|item| item.name}
    elsif max == nil
      where("unit_price > #{min}").sort_by {|item| item.name}
    elsif min == nil
      where("unit_price < #{max}").sort_by {|item| item.name}
    end
  end
end
