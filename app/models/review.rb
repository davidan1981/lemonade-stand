class Review < ActiveRecord::Base
  include Repia::UUIDModel
  acts_as_paranoid

  belongs_to :user, foreign_key: "user_uuid", primary_key: "uuid"
  belongs_to :product, foreign_key: "product_uuid", primary_key: "uuid"

  validates :user, presence: true
  validates :product, presence: true
  validates :score, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 5,
  }
  validates :feedback, presence: true, length: { minimum: 20 }
  validate :must_not_be_a_duplicate_review

  ##
  # A user cannot leave more than one review per product.
  #
  def must_not_be_a_duplicate_review
    dup_reviews = Review.where(user: user, product: product)
    if new_record?
      if dup_reviews.length > 0
        errors.add(:product, "already has a review from this user.")
      end
    elsif dup_reviews.length > 0 && !dup_reviews.include?(self)
      errors.add(:product, "already has a review from this user.")
    end
  end
end
