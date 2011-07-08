require 'test_helper'

class CsvFieldsControllerTest < ActionController::TestCase
  setup do
    @csv_field = csv_fields(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:csv_fields)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create csv_field" do
    assert_difference('CsvField.count') do
      post :create, :csv_field => @csv_field.attributes
    end

    assert_redirected_to csv_field_path(assigns(:csv_field))
  end

  test "should show csv_field" do
    get :show, :id => @csv_field.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @csv_field.to_param
    assert_response :success
  end

  test "should update csv_field" do
    put :update, :id => @csv_field.to_param, :csv_field => @csv_field.attributes
    assert_redirected_to csv_field_path(assigns(:csv_field))
  end

  test "should destroy csv_field" do
    assert_difference('CsvField.count', -1) do
      delete :destroy, :id => @csv_field.to_param
    end

    assert_redirected_to csv_fields_path
  end
end
