class User < RailsIdentity::User

  has_one :cart, foreign_key: "user_uuid", primary_key: "uuid"

  ##
  # Initializes a user object and automatically creates a cart object for
  # the user.
  #
  def initialize(attributes = {})
    super
    cart = Cart.new(user: self)
    cart.save()
  end
end
