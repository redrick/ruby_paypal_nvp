module RubyPaypalNvp
  module Fetcher
    class Balance < Base
      RESPONSE_PARAMS = %w[L_AMT L_CURRENCYCODE].freeze

      private

      def process_loaded_data(result)
        result = filter_current_currency(result)
        return if result[:values].blank?
        ::RubyPaypalNvp::Model::Balance.new(result)
      end

      def filter_current_currency(result)
        currency_code = result[:meta]['currency_code']
        balance = result[:values].select do |_key, value|
          { key: value } if value.values.include?(currency_code)
        end
        result[:values] = balance.values.first
        result
      end

      def load_response
        response = load_api_response(request_options)
        raise response['L_LONGMESSAGE0'] if response['ACK'] == 'Failure'
        parse(response, increment: 0)
        result = result_with_meta(timestamp: Time.zone.parse(response['TIMESTAMP']).to_s)
        @resulting_hash = default_hash
        result
      end

      def request_options
        super.merge! returnallcurrencies: 1
      end

      def api_method
        'GetBalance'
      end
    end
  end
end
