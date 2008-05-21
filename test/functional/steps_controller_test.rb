require File.dirname(__FILE__) + '/../test_helper'

class StepsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:steps)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_step
    assert_difference('Step.count') do
      post :create, :step => { }
    end

    assert_redirected_to step_path(assigns(:step))
  end

  def test_should_show_step
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_should_update_step
    put :update, :id => 1, :step => { }
    assert_redirected_to step_path(assigns(:step))
  end

  def test_should_destroy_step
    assert_difference('Step.count', -1) do
      delete :destroy, :id => 1
    end

    assert_redirected_to steps_path
  end
end
