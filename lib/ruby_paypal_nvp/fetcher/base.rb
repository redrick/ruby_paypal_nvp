##
# Base for fetching data from Paypal NVP API
#   See docs: https://developer.paypal.com/docs/classic/api/
##
module RubyPaypalNvp
  module Fetcher
    class Base
      def initialize(date, currency, subject = nil)
        @start_date = date.beginning_of_day.utc.iso8601
        @end_date = date.end_of_day.utc.iso8601
        @currency = currency
        @subject = subject || RubyPaypalNvp.configuration.subject
        @resulting_hash = default_hash
      end

      def call
        # begin
          result = load_response
          process_loaded_data(result)
        # rescue NoMethodError
        #   raise "Error processing #{self.class} for #{@subject}"
        # end
      end

      def self.call(date, currency, subject = nil)
        new(date, currency, subject).call
      end

      def load_api_response(options)
        res = Net::HTTP.post_form(URI(RubyPaypalNvp.configuration.api_url), options)
        pretty_json(res.body)
      end

      private

      def parse(body, options = {})
        @resulting_hash[:values].tap do |parsed_response|
          param_type = self.class::RESPONSE_PARAMS.first
          all_for_params_type = body.select { |k, _v| k.start_with?(param_type) }
          all_for_params_type.each_with_index do |(key, value), index|
            real_index = index + options[:increment]
            parsed_response[real_index] ||= {}
            parsed_response[real_index] = parsed_response[real_index].merge "#{param_type}" => value
            key = key.gsub(param_type, '')
            self.class::RESPONSE_PARAMS.drop(1).each do |attribute_name|
              pair = { attribute_name => body["#{attribute_name}#{key}"] }
              parsed_response[real_index] = parsed_response[real_index].merge pair
            end
          end
        end
      end

      # Implement in each child to save/send data
      def process_loaded_data(_account, _result)
        true
      end

      def result_with_meta(options = {})
        @resulting_hash[:meta]['timestamp'] = options[:timestamp]
        @resulting_hash[:meta]['start_date'] = @start_date
        @resulting_hash[:meta]['end_date'] = @end_date
        @resulting_hash[:meta]['subject'] = @subject
        @resulting_hash[:meta]['currency_code'] = @currency
        @resulting_hash
      end

      def request_options(options = {})
        {
          method: api_method,
          version: RubyPaypalNvp.configuration.version,
          user: RubyPaypalNvp.configuration.user,
          pwd: RubyPaypalNvp.configuration.password,
          signature: RubyPaypalNvp.configuration.signature,
          subject: @subject
        }
      end

      # Needs to be specific in each child
      def api_method
        ''
      end

      def pretty_json(body)
        Hash[URI.decode_www_form(body)]
      end

      def default_hash
        { meta: {}, values: {} }
      end
    end
  end
end
