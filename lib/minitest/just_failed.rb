# frozen_string_literal: true
require_relative "just_failed/version"
require "rails/railtie"
require_relative "just_failed/test_unit_reporter"
require_relative "composite_reporter"

module Minitest
  module JustFailed
    class Error < StandardError; end

    class LoadTasks < Rails::Railtie
      rake_tasks do
        load "#{__dir__}/just_failed/tasks/run_failed_tests.rake"
      end
    end
  end
end
