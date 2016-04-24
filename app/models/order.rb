class Order < ActiveRecord::Base
  include Repia::UUIDModel
  acts_as_paranoid

  belongs_to :user, foreign_key: "user_uuid", primary_key: "uuid"
  has_many :items, foreign_key: "order_uuid", primary_key: "uuid"

  validates :user, presence: true
  before_save :unlink_items_from_cart

  ##
  # Creates an order by importing items from a cart. This DOES NOT remove
  # items from the cart, which should be done once the order is confirmed.
  def self.from_cart(cart)
    return Order.new(user: cart.user, items: cart.items)
  end

  ##
  # Unlink items from cart if they still reference it.
  #
  def unlink_items_from_cart
    items.each do |item|
      item.cart = nil
      item.save
    end
  end

end
