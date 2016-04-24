require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test "product should have a unique title" do
    product1 = Product.new(
      title: products(:one).title,
      description: "This is a detailed description of product #1",
      sale_price: 89.00,
      base_shipping: 5.00,
      add_on_shipping: 3.00
    )
    assert_not product1.save()
    product1.title = "unique title"
    assert product1.save()
  end

  test "product calculates the average review score" do
    product = products(:one)
    assert product.avg_score > 0
  end

  test "product score is nil if no reviews" do
    product = products(:one)
    product.reviews.destroy(product.reviews.first)
    assert_nil product.avg_score
  end
end
