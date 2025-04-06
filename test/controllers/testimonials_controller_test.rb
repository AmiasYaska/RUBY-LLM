require "test_helper"

class TestimonialsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get testimonials_new_url
    assert_response :success
  end
end
