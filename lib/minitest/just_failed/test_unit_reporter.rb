require "minitest"

# See the original TestUnitReporter here:
# https://github.com/rails/rails/blob/main/railties/lib/rails/test_unit/reporter.rb
module Rails
  class TestUnitReporter < Minitest::StatisticsReporter
    @@failed_tests = []

    def log_failed_test(result)
      return unless output_inline? && result.failure && (!result.skipped? || options[:verbose])
      type = result.klass.constantize.ancestors.to_s.include?("ApplicationSystemTestCase") ? :system : :unit
      failed_test = {path: relative_path_for(result.source_location.join(":")), type: type}
      log_file, read_type = create_file_or_append_test_path(failed_test)

      File.open(log_file, read_type) do |f|
        f.write("#{failed_test[:path]}\n")
      end
      @@failed_tests << failed_test
    end

    private

    def unit_test?(ft)
      ft[:type] == :unit
    end

    def system_test?(ft)
      ft[:type] == :system
    end

    # We want a clean file if it's the first failure in the process to keep the log recent.
    # "w+" will create a new file, whereas "a" will simply append the test path.
    def create_file_or_append_test_path(current_ft)
      Dir.mkdir("#{Rails.root}/log/failed") unless Dir.exist?("#{Rails.root}/log/failed")
      Dir.mkdir("#{Rails.root}/log/failed/system") unless Dir.exist?("#{Rails.root}/log/failed/system")
      log_file = unit_test?(current_ft) ? "#{Rails.root}/log/failed/tests.log" : "#{Rails.root}/log/failed/system/tests.log"

      test_exists = false
      read_type = nil
      @@failed_tests.each do |previously_failed_test|
        if (unit_test?(current_ft) && unit_test?(previously_failed_test)) ||
            (system_test?(current_ft) && system_test?(previously_failed_test))
          test_exists = true
        end
        read_type = "a" if test_exists
        break if test_exists
      end
      read_type ||= "w+"
      [log_file, read_type]
    end
  end
end
