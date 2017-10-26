module RubyPaypalNvp
  module Model
    class Statement
      attr_accessor :timestamp, :start_date, :end_date, :subject,
        :currency_code, :items, :amount_sum, :fee_amount_sum, :net_amount_sum

      def initialize(result)
        @timestamp = result[:meta]['timestamp']
        @start_date = result[:meta]['start_date']
        @end_date = result[:meta]['end_date']
        @subject = result[:meta]['subject']
        @currency_code = result[:meta]['currency_code']
        @items = result[:values].map do |value|
          Item.new(value)
        end
        @amount_sum = @items.sum(&:amount)
        @fee_amount_sum = @items.sum(&:fee_amount)
        @net_amount_sum = @items.sum(&:net_amount)
      end
    end
  end
end
