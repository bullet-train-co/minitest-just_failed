require "test_helper"
require "application_system_test_case"

class JustFailedTest < ActiveSupport::TestCase
  # We run this and #after_tests when the tests are finished so
  # we don't get rid of any previously exisitng failing tests.
  @failed_file_paths = save_stored_failures
  clear_failed_tests_log

  Rails.application.load_tasks

  class ExampleTest < Minitest::Test
    def foo
    end
  end

  class ExampleSystemTest < ApplicationSystemTestCase
    def foo
    end
  end

  # Similar to TestUnitReporter's test setup in the Rails repository
  def setup
    @output = StringIO.new
    @reporter = Rails::TestUnitReporter.new @output, output_inline: true
  end

  def teardown
    clear_failed_tests_log
  end

  Minitest::Unit.after_tests do
    reapply_stored_failures(@failed_file_paths)
  end

  test "failed unit tests are logged to proper file" do
    ft = failed_test(:unit)
    @reporter.log_failed_test(ft)

    logged_file = from_logger(failed_unit_test_log_path)
    file_from_reporter = from_reporter(ft)
    assert_equal logged_file, file_from_reporter
  end

  test "failed system tests are logged to the proper file" do
    ft = failed_test(:system)
    @reporter.log_failed_test(ft)

    logged_file = from_logger(failed_system_test_log_path)
    file_from_reporter = from_reporter(ft)
    assert_equal logged_file, file_from_reporter
  end

  test "test:failed runs failed unit tests only" do
    log_all_dummy_tests
    Rake::Task["test:failed"].invoke
    assert_equal unit_test_success_message, from_logger(failed_unit_test_log_path)
    refute_equal system_test_success_message, from_logger(failed_system_test_log_path)
  end

  test "test:system:failed runs system tests only" do
    log_all_dummy_tests
    Rake::Task["test:system:failed"].invoke
    refute_equal unit_test_success_message, from_logger(failed_unit_test_log_path)
    assert_equal system_test_success_message, from_logger(failed_system_test_log_path)
  end

  test "test:all:failed runs both unit and system tests" do
    log_all_dummy_tests
    Rake::Task["test:all:failed"].invoke
    assert_equal unit_test_success_message, from_logger(failed_unit_test_log_path)
    assert_equal system_test_success_message, from_logger(failed_system_test_log_path)
  end

  # We log the following tests as if they are failing so we can test `rails test:failed`, etc.
  def log_all_dummy_tests
    clear_failed_tests_log
    File.open(failed_unit_test_log_path, "w+") do |f|
      f.write("test/dummy_unit_test.rb")
    end

    File.open(failed_system_test_log_path, "w+") do |f|
      f.write("test/dummy_system_test.rb")
    end
  end

  # Gets the file names logged in failed/
  def from_logger(file_path)
    File.open(file_path).readlines.first.delete("\n")
  end

  # Gets the file name from the TestUnitReporter itself
  def from_reporter(ft)
    ft.source_location.join(":").gsub("#{Rails.root}/", "")
  end

  def unit_test_success_message
    "The unit test was successfully executed"
  end

  def system_test_success_message
    "The system test was successfully executed"
  end

  # Similar to #failed_test in the rails TestUnitReporter test
  def failed_test(type)
    test_class = type == :unit ? ExampleTest : ExampleSystemTest

    ft = Minitest::Result.from(test_class.new(:foo))
    ft.failures << begin
      raise Minitest::Assertion, "Failing test"
    rescue Minitest::Assertion => e
      e
    end
    ft
  end
end
