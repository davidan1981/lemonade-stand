class User < RailsIdentity::User

  has_one :cart, foreign_key: "user_uuid", primary_key: "uuid"

  def initialize(attributes = {})
    super
    cart = Cart.new(user: self)
    cart.save()
  end
end
