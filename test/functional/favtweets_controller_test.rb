require 'test_helper'

class FavtweetsControllerTest < ActionController::TestCase
  setup do
    @favtweet = favtweets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:favtweets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create favtweet" do
    assert_difference('Favtweet.count') do
      post :create, favtweet: { contenthash: @favtweet.contenthash, full_text: @favtweet.full_text, screen_name: @favtweet.screen_name, timestamp: @favtweet.timestamp }
    end

    assert_redirected_to favtweet_path(assigns(:favtweet))
  end

  test "should show favtweet" do
    get :show, id: @favtweet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @favtweet
    assert_response :success
  end

  test "should update favtweet" do
    put :update, id: @favtweet, favtweet: { contenthash: @favtweet.contenthash, full_text: @favtweet.full_text, screen_name: @favtweet.screen_name, timestamp: @favtweet.timestamp }
    assert_redirected_to favtweet_path(assigns(:favtweet))
  end

  test "should destroy favtweet" do
    assert_difference('Favtweet.count', -1) do
      delete :destroy, id: @favtweet
    end

    assert_redirected_to favtweets_path
  end
end
