class Cart < ActiveRecord::Base
  include Repia::UUIDModel
  acts_as_paranoid

  belongs_to :user, foreign_key: "user_uuid", primary_key: "uuid"
  has_many :items, foreign_key: "cart_uuid", primary_key: "uuid"

  validates :user, presence: true
  validate :must_have_no_duplicate_products
  validate :only_one_cart_per_user

  ##
  # Allow only one cart per user.
  #
  def only_one_cart_per_user
    carts = Cart.where(user_uuid: user_uuid)
    if carts.length > 1
      # :nocov:
      errors.add(:user_uuid, "already has a cart")
      # :nocov:
    elsif carts.length == 1 && carts.first != self
      errors.add(:user_uuid, "already has a cart")
    end
  end

  ##
  # Ensure that no duplicate products exist in the cart. That is, each item
  # must be a unique product within the cart.
  #
  def must_have_no_duplicate_products
    seen = []
    items.each do |item|
      if seen.include?(item.product.uuid) then
        errors.add(:items, "cannot have duplicate products")
      else
        seen << item.product.uuid
      end
    end
  end

  ##
  # Calculates the shipping amount for the whole cart. If there is only one
  # item with a quantity of 1, the original shipping is used for that
  # product. Otherwise, use add-on shipping cost.
  #
  def shipping
    total_quantity = items.inject(0) {|q, item| q + item.quantity}
    if total_quantity == 1
      return items.first.product.base_shipping
    else
      return items.inject(0) {|total, item|
        total + (item.product.add_on_shipping * item.quantity)
      }
    end
  end

  ##
  # This method calculates the subtotal of the whole cart. The amount is
  # before tax and shipping amount.
  def subtotal
    return items.inject(0) {|total, item| total + item.subtotal}
  end

  # # Total before tax is shipping plus subtotal.
  # def total_before_tax
  #   return shipping + subtotal
  # end
end
