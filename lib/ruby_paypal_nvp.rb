require 'ruby_paypal_nvp/version'
require 'ruby_paypal_nvp/configuration'

module RubyPaypalNvp
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
