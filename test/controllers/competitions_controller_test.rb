require 'test_helper'

class CompetitionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @competition = competitions(:one)
  end

  test "should get index" do
    get competitions_url
    assert_response :success
  end

  test "should get new" do
    get new_competition_url
    assert_response :success
  end

  test "should create competition" do
    assert_difference('Competition.count') do
      post competitions_url, params: { competition: { evaluation_type: @competition.evaluation_type, max_team_size: @competition.max_team_size, name: @competition.name } }
    end

    assert_redirected_to competition_url(Competition.last)
  end

  test "should show competition" do
    get competition_url(@competition)
    assert_response :success
  end

  test "should get edit" do
    get edit_competition_url(@competition)
    assert_response :success
  end

  test "should update competition" do
    patch competition_url(@competition), params: { competition: { evaluation_type: @competition.evaluation_type, max_team_size: @competition.max_team_size, name: @competition.name } }
    assert_redirected_to competition_url(@competition)
  end

  test "should destroy competition" do
    assert_difference('Competition.count', -1) do
      delete competition_url(@competition)
    end

    assert_redirected_to competitions_url
  end
end
