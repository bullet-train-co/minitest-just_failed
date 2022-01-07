# frozen_string_literal: true
require_relative "just_failed/version"
require "rails/railtie"

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
