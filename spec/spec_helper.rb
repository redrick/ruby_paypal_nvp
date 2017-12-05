require "bundler/setup"
require "ruby_paypal_nvp"
Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |f| require f  }

require 'pry'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  RubyPaypalNvp.configure do |c|
    c.user = '1_api1.zakaznik.com'
    c.password = 'KR55T5PGFZWK62BD'
    c.signature = 'AOh0tu.5JUQyG2Aao4MpntBA2sFjA3Ld6MpS.Qgj8BaRaLlQZaSOV6Ti'
    c.api_url = 'https://api-3t.sandbox.paypal.com/nvp'
  end
end
