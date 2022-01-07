module Minitest
  class CompositeReporter < AbstractReporter
    def record(result)
      reporters.each do |reporter|
        reporter.record(result)
        if reporter.is_a?(Rails::TestUnitReporter) && result.failure.present?
          reporter.log_failed_test(result)
        end
      end
    end
  end
end
