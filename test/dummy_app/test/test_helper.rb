ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

def failed_unit_test_log_path
  "#{Rails.root}/log/failed/tests.log"
end

def failed_system_test_log_path
  "#{Rails.root}/log/failed/system/tests.log"
end

def save_stored_failures
  unit_tests = File.exist?(failed_unit_test_log_path) ? File.open(failed_unit_test_log_path).readlines : []
  system_tests = File.exist?(failed_system_test_log_path) ? File.open(failed_system_test_log_path).readlines : []
  [unit_tests, system_tests].flatten
end

def reapply_stored_failures(failed_file_paths)
  clear_failed_tests_log
  failed_file_paths.each do |ff|
    if ff.include?("system")
      File.open(failed_system_test_log_path, "a") do |f|
        f.write(ff)
      end
    else
      File.open(failed_unit_test_log_path, "a") do |f|
        f.write(ff)
      end
    end
  end
end

# We clear out all dummy failures created by the TestUnitReporter test
# if the developer's failing test logs were empty to begin with.
def clear_failed_tests_log
  Dir.mkdir("#{Rails.root}/log/failed") unless Dir.exist?("#{Rails.root}/log/failed")
  Dir.mkdir("#{Rails.root}/log/failed/system") unless Dir.exist?("#{Rails.root}/log/failed/system")
  [failed_unit_test_log_path, failed_system_test_log_path].each do |log|
    File.open(log, "w+") do |f|
      f.write("")
    end
  end
end
