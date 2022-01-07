namespace :test do
  desc "Run unit tests that failed most recently"
  task :failed do
    Rails::TestUnit::Runner.rake_run(retrieve_tests)
  end

  desc "Run system tests that failed most recently"
  namespace :system do
    task :failed do
      Rails::TestUnit::Runner.rake_run(retrieve_tests(:system))
    end
  end

  desc "Run tests that failed most recently"
  namespace :all do
    task :failed do
      Rails::TestUnit::Runner.rake_run(retrieve_tests(:all))
    end
  end
end

def retrieve_tests(type = :unit)
  case type
  when :unit
    unit_tests
  when :system
    system_tests
  when :all
    all_tests
  end
end

def unit_tests
  File.open("#{Rails.root}/log/failed/tests.log", "r") do |f|
    f.readlines
  end
end

def system_tests
  File.open("#{Rails.root}/log/failed/system/tests.log", "r") do |f|
    f.readlines
  end
end

def all_tests
  [unit_tests, system_tests].flatten
end
