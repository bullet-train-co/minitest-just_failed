require "test_helper"
require "application_system_test_case"

class DummySystemTest < ApplicationSystemTestCase
  test "Fires when running test:system:failed or test:all:failed" do
    File.open(failed_system_test_log_path, "w+") do |f|
      f.write("The system test was successfully executed")
    end
    assert true
  end
end
