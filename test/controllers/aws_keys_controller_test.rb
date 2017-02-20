require 'test_helper'

class AwsKeysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @aws_key = aws_keys(:one)
  end

  test "should get index" do
    get aws_keys_url
    assert_response :success
  end

  test "should get new" do
    get new_aws_key_url
    assert_response :success
  end

  test "should create aws_key" do
    assert_difference('AwsKey.count') do
      post aws_keys_url, params: { aws_key: { accessKey: @aws_key.accessKey, default: @aws_key.default, name: @aws_key.name, region: @aws_key.region, secretKey: @aws_key.secretKey } }
    end

    assert_redirected_to aws_key_url(AwsKey.last)
  end

  test "should show aws_key" do
    get aws_key_url(@aws_key)
    assert_response :success
  end

  test "should get edit" do
    get edit_aws_key_url(@aws_key)
    assert_response :success
  end

  test "should update aws_key" do
    patch aws_key_url(@aws_key), params: { aws_key: { accessKey: @aws_key.accessKey, default: @aws_key.default, name: @aws_key.name, region: @aws_key.region, secretKey: @aws_key.secretKey } }
    assert_redirected_to aws_key_url(@aws_key)
  end

  test "should destroy aws_key" do
    assert_difference('AwsKey.count', -1) do
      delete aws_key_url(@aws_key)
    end

    assert_redirected_to aws_keys_url
  end
end
