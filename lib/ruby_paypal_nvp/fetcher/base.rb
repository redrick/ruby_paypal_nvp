##
# Base for fetching data from Paypal NVP API
#   See docs: https://developer.paypal.com/docs/classic/api/
##
module RubyPaypalNvp
  module Fetcher
    class Base
      ##
      # Input options:
      #   date_from
      #   date_to
      #   currency
      #   subject
      #   transaction_class
      #
      # rubocop:disable Metrics/AbcSize
      def initialize(opts)
        @start_date = opts.fetch(:date_from, Time.zone.now).beginning_of_day.utc.iso8601
        @end_date = opts.fetch(:date_to, Time.zone.now).end_of_day.utc.iso8601
        @currency = opts.fetch(:currency, 'CZK')
        @subject = opts[:subject] || RubyPaypalNvp.configuration.subject
        @transaction_class = opts.fetch(:transaction_class, 'BalanceAffecting')
        @resulting_hash = default_hash
      end
      # rubocop:enable Metrics/AbcSize

      def call
        result = load_response
        process_loaded_data(result)
      rescue NoMethodError
        raise "Error processing #{self.class} for #{@subject}"
      end

      def self.call(options)
        new(options).call
      end

      def load_api_response(options)
        uri = URI(RubyPaypalNvp.configuration.api_url)
        req = Net::HTTP::Post.new(uri)
        req.set_form_data(options)
        res = Net::HTTP.start(uri.hostname, uri.port,
                              use_ssl: uri.scheme == 'https') do |http|
          http.open_timeout = 6000
          http.read_timeout = 6000
          http.request(req)
        end
        pretty_json(res.body)
      end

      private

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def parse(body, options = {})
        @resulting_hash[:values].tap do |parsed_response|
          param_type = self.class::RESPONSE_PARAMS.first
          all_for_params_type = body.select { |k, _v| k.start_with?(param_type) }
          all_for_params_type.each_with_index do |(key, value), index|
            real_index = index + options[:increment]
            parsed_response[real_index] ||= {}
            parsed_response[real_index] = parsed_response[real_index]
                                          .merge(param_type.to_s => value)
            key = key.gsub(param_type, '')
            self.class::RESPONSE_PARAMS.drop(1).each do |attribute_name|
              pair = { attribute_name => body["#{attribute_name}#{key}"] }
              parsed_response[real_index] = parsed_response[real_index].merge pair
            end
          end
        end
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/MethodLength

      # Implement in each child to save/send data
      def process_loaded_data(_result)
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

      def request_options(_options = {})
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
