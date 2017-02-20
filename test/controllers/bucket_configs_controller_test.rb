require 'test_helper'

class BucketConfigsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bucket_config = bucket_configs(:one)
  end

  test "should get index" do
    get bucket_configs_url
    assert_response :success
  end

  test "should get new" do
    get new_bucket_config_url
    assert_response :success
  end

  test "should create bucket_config" do
    assert_difference('BucketConfig.count') do
      post bucket_configs_url, params: { bucket_config: { bucketname: @bucket_config.bucketname, region: @bucket_config.region, servicename: @bucket_config.servicename, user_id: @bucket_config.user_id } }
    end

    assert_redirected_to bucket_config_url(BucketConfig.last)
  end

  test "should show bucket_config" do
    get bucket_config_url(@bucket_config)
    assert_response :success
  end

  test "should get edit" do
    get edit_bucket_config_url(@bucket_config)
    assert_response :success
  end

  test "should update bucket_config" do
    patch bucket_config_url(@bucket_config), params: { bucket_config: { bucketname: @bucket_config.bucketname, region: @bucket_config.region, servicename: @bucket_config.servicename, user_id: @bucket_config.user_id } }
    assert_redirected_to bucket_config_url(@bucket_config)
  end

  test "should destroy bucket_config" do
    assert_difference('BucketConfig.count', -1) do
      delete bucket_config_url(@bucket_config)
    end

    assert_redirected_to bucket_configs_url
  end
end
