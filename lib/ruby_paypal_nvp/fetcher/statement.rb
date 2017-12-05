module RubyPaypalNvp
  module Fetcher
    class Statement < Base
      RESPONSE_PARAMS = %w[L_TIMESTAMP L_TIMEZONE L_TYPE L_EMAIL L_NAME
                           L_TRANSACTIONID L_STATUS L_AMT L_CURRENCYCODE
                           L_FEEAMT L_NETAMT].freeze

      private

      def process_loaded_data(result)
        ::RubyPaypalNvp::Model::Statement.new(result)
      end

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def load_response
        @ack = 'Failure'
        while @ack != 'Success'
          enddate = moved_end ? Time.parse(moved_end).utc.iso8601 : nil
          options = request_options(enddate: enddate)
          response = load_api_response(options)
          parse(response, increment: increment)

          @ack = response['ACK']
          raise response['L_LONGMESSAGE0'] if @ack == 'Failure'
        end
        result = result_with_meta(timestamp: response['TIMESTAMP'])
        @resulting_hash = default_hash
        result[:values] = result[:values].values
        result
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/MethodLength

      # rubocop:disable Style/GuardClause
      def moved_end
        if @resulting_hash[:values].keys.last
          @resulting_hash[:values].values.last['L_TIMESTAMP']
        end
      end
      # rubocop:enable Style/GuardClause

      def increment
        if @resulting_hash[:values].keys.last
          (@resulting_hash[:values].keys.last + 1)
        else
          0
        end
      end

      def request_options(options = {})
        additional = {
          startdate: @start_date,
          enddate: options[:enddate] || @end_date,
          transactionclass: @transaction_class,
          currencycode: @currency
        }
        super.merge! additional
      end

      def api_method
        'TransactionSearch'
      end
    end
  end
end
