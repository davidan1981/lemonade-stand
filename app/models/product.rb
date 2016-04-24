class Product < ActiveRecord::Base
  include Repia::UUIDModel
  acts_as_paranoid

  has_many :product_images, foreign_key: "product_uuid", primary_key: "uuid"
  has_many :reviews, foreign_key: "product_uuid", primary_key: "uuid"

  validates :title, presence: true, uniqueness: true
  validates :description, presence: true
  validates :quantity, allow_nil: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :sale_price, presence: true, numericality: { greater_than_or_equal_to: 0.0 }
  validates :base_shipping, presence: true, numericality: { greater_than_or_equal_to: 0.0 }
  validates :add_on_shipping, presence: true, numericality: { greater_than_or_equal_to: 0.0 }

  # Calculates the average score from the reviews.
  def avg_score
    if reviews.length == 0
      return nil
    else
      total = reviews.inject(0) { |t, r| t + r.score }
      return total.to_f / reviews.length
    end
  end

end
