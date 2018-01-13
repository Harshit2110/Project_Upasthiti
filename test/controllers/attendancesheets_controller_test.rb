require 'test_helper'

class AttendancesheetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @attendancesheet = attendancesheets(:one)
  end

  test "should get index" do
    get attendancesheets_url
    assert_response :success
  end

  test "should get new" do
    get new_attendancesheet_url
    assert_response :success
  end

  test "should create attendancesheet" do
    assert_difference('Attendancesheet.count') do
      post attendancesheets_url, params: { attendancesheet: {  } }
    end

    assert_redirected_to attendancesheet_url(Attendancesheet.last)
  end

  test "should show attendancesheet" do
    get attendancesheet_url(@attendancesheet)
    assert_response :success
  end

  test "should get edit" do
    get edit_attendancesheet_url(@attendancesheet)
    assert_response :success
  end

  test "should update attendancesheet" do
    patch attendancesheet_url(@attendancesheet), params: { attendancesheet: {  } }
    assert_redirected_to attendancesheet_url(@attendancesheet)
  end

  test "should destroy attendancesheet" do
    assert_difference('Attendancesheet.count', -1) do
      delete attendancesheet_url(@attendancesheet)
    end

    assert_redirected_to attendancesheets_url
  end
end
