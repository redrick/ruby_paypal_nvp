require 'csv'

module RubyPaypalNvp
  module Model
    class Statement
      attr_accessor :timestamp, :start_date, :end_date, :subject,
                    :currency_code, :items, :amount_sum, :fee_amount_sum,
                    :net_amount_sum, :items_count

      IGNORED_STATUSES = %w[Cleared Placed Removed].freeze

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def initialize(result)
        @timestamp = result[:meta]['timestamp']
        @start_date = result[:meta]['start_date']
        @end_date = result[:meta]['end_date']
        @subject = result[:meta]['subject']
        @currency_code = result[:meta]['currency_code']
        @items = result[:values].map do |value|
          Item.new(value) unless IGNORED_STATUSES.include?(value['L_STATUS'])
        end.compact.uniq(&:transaction_id)
        @items_count = @items.count
        @amount_sum = @items.sum(&:amount)
        @fee_amount_sum = @items.sum(&:fee_amount)
        @net_amount_sum = @items.sum(&:net_amount)
        @raw = result
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/MethodLength

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def generate_csv(filename = nil)
        raise 'Missing filename/path' unless filename
        ::CSV.open(filename, 'w') do |csv|
          csv << ['HEADER']
          csv << ['', 'timestamp', @timestamp]
          csv << ['', 'start_date', @start_date]
          csv << ['', 'end_date', @end_date]
          csv << ['', 'subject', @subject]
          csv << ['', 'currency_code', @currency_code]
          csv << ['', 'items_count', @items_count]
          csv << ['', 'amount_sum', @amount_sum]
          csv << ['', 'fee_amount_sum', @fee_amount_sum]
          csv << ['', 'net_amount_sum', @net_amount_sum]
          csv << ['ITEMS']
          csv << RubyPaypalNvp::Model::Item.attributes
          @items.each do |item|
            csv << item.to_csv
          end
        end
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/MethodLength

      def to_json
        raw_items.to_json
      end

      def to_iis_json
        {
          'meta': {
            'timestamp': @timestamp,
            'start_date': @start_date,
            'end_date': @end_date,
            'subject': @subject,
            'currency_code': @currency_code
          },
          'values': raw_items
        }.to_json
      end

      private

      def raw_items
        @raw[:values].compact.uniq { |i| i['L_TRANSACTIONID'] }
      end
    end
  end
end
