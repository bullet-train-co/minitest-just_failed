require "test_helper"

class DummyUnitTest < ActiveSupport::TestCase
  test "Fires when running test:failed or test:all:failed" do
    File.open(failed_unit_test_log_path, "w+") do |f|
      f.write("The unit test was successfully executed")
    end
    assert true
  end
end
