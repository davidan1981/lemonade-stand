require 'test_helper'

class ReviewTest < ActiveSupport::TestCase

  test "user cannot write more than one review for the same product" do
    review = Review.new(
      feedback: "This is a duplicate review",
      score: 1,
      user: users(:one),
      product: products(:one)
    )
    assert_not review.save()
    review.product = products(:two)
    assert review.save()
    review.product = products(:one)
    assert_not review.save()
  end

  test "feedback must be 20 or more characters" do
    feedback = "0123456789"
    review = Review.new(
      feedback: feedback,
      score: 5,
      user: users(:one),
      product: products(:two)
    )
    assert_not review.save()
    review.feedback = feedback * 3
    assert review.save()
  end

  test "score must be between 1-5 inclusive" do
    review = Review.new(
      feedback: "This product is blah blah blah....",
      score: 0,
      user: users(:one),
      product: products(:two)
    )
    assert_not review.save()
    (1..5).each do |score|
      review.score = score
      assert review.validate()
    end
    review.score = 6
    assert_not review.validate()
  end

end
