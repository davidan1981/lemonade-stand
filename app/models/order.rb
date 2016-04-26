class Order < ActiveRecord::Base
  include Repia::UUIDModel
  acts_as_paranoid

  belongs_to :user, foreign_key: "user_uuid", primary_key: "uuid"
  has_many :items, foreign_key: "order_uuid", primary_key: "uuid"

  validates :user, presence: true

  ##
  # Creates an order by importing items from a cart. Also, move each item
  # out of the cart.
  #
  def self.from_cart(cart)
    order = Order.new(user: cart.user)
    order.save
    cart.items.each do |item|
      item.cart = nil
      item.order = order
      item.save
    end
    cart.items.clear
    cart.save
    return order
  end

end
