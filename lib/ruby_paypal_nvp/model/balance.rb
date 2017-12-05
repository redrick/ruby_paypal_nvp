module RubyPaypalNvp
  module Model
    class Balance
      attr_accessor :currency_code, :subject, :timestamp, :opening_balance

      def initialize(result)
        @currency_code = result[:meta]['currency_code']
        @subject = result[:meta]['subject']
        @timestamp = result[:meta]['timestamp']
        @opening_balance = result[:values]['L_AMT'].to_f
      end
    end
  end
end
