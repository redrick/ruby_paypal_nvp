module RubyPaypalNvp
  module Model
    class Item
      attr_accessor :timestamp, :timezone, :type, :email, :name,
        :transaction_id, :status, :amount, :currency_code, :fee_amount,
        :net_amount

      def initialize(hash = {})
        @timestamp = hash['L_TIMESTAMP'] || nil
        @timezone = hash['L_TIMEZONE'] || nil
        @type = hash['L_TYPE'] || nil
        @email = hash['L_EMAIL'] || nil
        @name = hash['L_NAME'] || nil
        @transaction_id = hash['L_TRANSACTIONID'] || nil
        @status = hash['L_STATUS'] || nil
        @amount = (hash['L_AMT'] || nil).to_f
        @currency_code = hash['L_CURRENCYCODE'] || nil
        @fee_amount = (hash['L_FEEAMT'] || nil).to_f
        @net_amount = (hash['L_NETAMT'] || nil).to_f
      end

      def self.attributes
        self.new.instance_variable_names.map { |a| a.delete('@')  }
      end

      def to_csv
        instance_variables.map { |k| self.instance_variable_get(k) }
      end
    end
  end
end
