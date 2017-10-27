require 'csv'

module RubyPaypalNvp
  module Model
    class Statement
      attr_accessor :timestamp, :start_date, :end_date, :subject,
        :currency_code, :items, :amount_sum, :fee_amount_sum, :net_amount_sum,
        :items_count

      def initialize(result)
        @timestamp = result[:meta]['timestamp']
        @start_date = result[:meta]['start_date']
        @end_date = result[:meta]['end_date']
        @subject = result[:meta]['subject']
        @currency_code = result[:meta]['currency_code']
        @items = result[:values].map do |value|
          Item.new(value)
        end
        @items_count = @items.count
        @amount_sum = @items.sum(&:amount)
        @fee_amount_sum = @items.sum(&:fee_amount)
        @net_amount_sum = @items.sum(&:net_amount)
      end

      def generate_csv(filename = nil)
        raise 'Missing filename/path' unless filename
        ::CSV.open(filename, 'w') do |csv|
          csv << ['HEADER']
          csv << ['', 'timestamp', @timestamp]
          csv << ['', 'start_date', @start_date]
          csv << ['', 'end_date', @end_date]
          csv << ['', 'subject', @subject]
          csv << ['', 'currency_code', @currency_code]
          csv << ['ITEMS']
          csv << RubyPaypalNvp::Model::Item.attributes
          @items.each do |item|
            csv << item.to_csv
          end
        end
      end
    end
  end
end
