require 'bundler/setup'
require 'simplecov'
require 'codacy-coverage'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
    [
        SimpleCov::Formatter::HTMLFormatter,
        Codacy::Formatter
    ]
)
SimpleCov.start

require 'sportsflix'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered                = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
