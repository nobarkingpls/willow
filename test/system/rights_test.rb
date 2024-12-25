require "application_system_test_case"

class RightsTest < ApplicationSystemTestCase
  setup do
    @right = rights(:one)
  end

  test "visiting the index" do
    visit rights_url
    assert_selector "h1", text: "Rights"
  end

  test "should create right" do
    visit rights_url
    click_on "New right"

    fill_in "Country", with: @right.country
    fill_in "End", with: @right.end
    fill_in "Movie", with: @right.movie_id
    fill_in "Start", with: @right.start
    click_on "Create Right"

    assert_text "Right was successfully created"
    click_on "Back"
  end

  test "should update Right" do
    visit right_url(@right)
    click_on "Edit this right", match: :first

    fill_in "Country", with: @right.country
    fill_in "End", with: @right.end.to_s
    fill_in "Movie", with: @right.movie_id
    fill_in "Start", with: @right.start.to_s
    click_on "Update Right"

    assert_text "Right was successfully updated"
    click_on "Back"
  end

  test "should destroy Right" do
    visit right_url(@right)
    click_on "Destroy this right", match: :first

    assert_text "Right was successfully destroyed"
  end
end
