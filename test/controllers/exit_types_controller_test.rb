require "test_helper"

class ExitTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @exit_type = exit_types(:one)
  end

  test "should get index" do
    get exit_types_url
    assert_response :success
  end

  test "should get new" do
    get new_exit_type_url
    assert_response :success
  end

  test "should create exit_type" do
    assert_difference('ExitType.count') do
      post exit_types_url, params: { exit_type: { disabled: @exit_type.disabled, name: @exit_type.name, organization_id: @exit_type.organization_id } }
    end

    assert_redirected_to exit_type_url(ExitType.last)
  end

  test "should show exit_type" do
    get exit_type_url(@exit_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_exit_type_url(@exit_type)
    assert_response :success
  end

  test "should update exit_type" do
    patch exit_type_url(@exit_type), params: { exit_type: { disabled: @exit_type.disabled, name: @exit_type.name, organization_id: @exit_type.organization_id } }
    assert_redirected_to exit_type_url(@exit_type)
  end

  test "should destroy exit_type" do
    assert_difference('ExitType.count', -1) do
      delete exit_type_url(@exit_type)
    end

    assert_redirected_to exit_types_url
  end
end
