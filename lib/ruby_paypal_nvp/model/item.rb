module RubyPaypalNvp
  module Model
    class Item
      attr_accessor :timestamp, :timezone, :type, :email, :name,
        :transaction_id, :status, :amount, :currency_code, :fee_amount,
        :net_amount

      def initialize(hash)
        @timestamp = hash['L_TIMESTAMP']
        @timezone = hash['L_TIMEZONE']
        @type = hash['L_TYPE']
        @email = hash['L_EMAIL']
        @name = hash['L_NAME']
        @transaction_id = hash['L_TRANSACTIONID']
        @status = hash['L_STATUS']
        @amount = hash['L_AMT'].to_f
        @currency_code = hash['L_CURRENCYCODE']
        @fee_amount = hash['L_FEEAMT'].to_f
        @net_amount = hash['L_NETAMT'].to_f
      end
    end
  end
end
