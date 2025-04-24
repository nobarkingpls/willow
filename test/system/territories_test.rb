require "application_system_test_case"

class TerritoriesTest < ApplicationSystemTestCase
  setup do
    @territory = territories(:one)
  end

  test "visiting the index" do
    visit territories_url
    assert_selector "h1", text: "Territories"
  end

  test "should create territory" do
    visit territories_url
    click_on "New territory"

    fill_in "Code", with: @territory.code
    click_on "Create Territory"

    assert_text "Territory was successfully created"
    click_on "Back"
  end

  test "should update Territory" do
    visit territory_url(@territory)
    click_on "Edit this territory", match: :first

    fill_in "Code", with: @territory.code
    click_on "Update Territory"

    assert_text "Territory was successfully updated"
    click_on "Back"
  end

  test "should destroy Territory" do
    visit territory_url(@territory)
    click_on "Destroy this territory", match: :first

    assert_text "Territory was successfully destroyed"
  end
end
