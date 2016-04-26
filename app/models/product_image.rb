class ProductImage < ActiveRecord::Base
  include Repia::UUIDModel
  acts_as_paranoid

  belongs_to :product, foreign_key: "product_uuid", primary_key: "uuid"
  validates :url, presence: true
end
