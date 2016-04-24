class Item < ActiveRecord::Base
  include Repia::UUIDModel
  acts_as_paranoid

  belongs_to :product, foreign_key: "product_uuid", primary_key: "uuid"
  belongs_to :cart, foreign_key: "cart_uuid", primary_key: "uuid"
  belongs_to :order, foreign_key: "order_uuid", primary_key: "uuid"

  validates :product, presence: true
  validates :quantity, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1
  }
  validate :must_belong_to_either_cart_or_order

  # Custom validation method to ensure an item _always_ belongs to a cart or
  # an order (but not both).
  def must_belong_to_either_cart_or_order
    if cart.present? && order.present?
      errors.add(:cart, "and order both cannot own item at the same time")
    elsif !(cart.present? || order.present?)
      errors.add(:cart, "or order must be not nil")
    end
  end

  # Calculates the line item subtotal price, which is the sale price
  # multiplied by the quantity.
  def subtotal
    return product.sale_price * quantity
  end
end
