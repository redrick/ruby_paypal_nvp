RSpec.describe RubyPaypalNvp::Statement do
  describe 'where' do
    it "returns statement for given search params (person - CZK)" do
      VCR.use_cassette 'statement_success_person' do
        @statement = RubyPaypalNvp::Statement
          .where(date_from: Time.zone.parse('1.1.2017'),
                 date_to: Time.zone.parse('3.12.2017'),
                 subject: '1@zakaznik.com',
                 currency: 'CZK')
      end

      expect(@statement).to be_a(RubyPaypalNvp::Model::Statement)
      expect(@statement.amount_sum).to eq(63000)
      expect(@statement.currency_code).to eq("CZK")
      expect(@statement.end_date).to eq("2017-12-03T22:59:59Z")
      expect(@statement.fee_amount_sum).to eq(0.0)
      expect(@statement.items.count).to eq(2)
      expect(@statement.subject).to eq('1@zakaznik.com')

      expect(@statement.items).to all(be_a(RubyPaypalNvp::Model::Item))
      expect(@statement.items.map(&:amount).reduce(:+)).to eq(@statement.amount_sum)
    end

    it "returns statement for given search params (merchant - CZK)" do
      VCR.use_cassette 'statement_success_merchant_czk' do
        @statement = RubyPaypalNvp::Statement
          .where(date_from: Time.zone.parse('1.1.2017'),
                 date_to: Time.zone.parse('3.12.2017'),
                 subject: '2@zakaznik.com',
                 currency: 'CZK')
      end

      expect(@statement).to be_a(RubyPaypalNvp::Model::Statement)
      expect(@statement.amount_sum).to eq(-63725.9)
      expect(@statement.currency_code).to eq("CZK")
      expect(@statement.end_date).to eq("2017-12-03T22:59:59Z")
      expect(@statement.fee_amount_sum).to eq(-689.0)
      expect(@statement.items.count).to eq(5)
      expect(@statement.subject).to eq('2@zakaznik.com')

      expect(@statement.items).to all(be_a(RubyPaypalNvp::Model::Item))
      expect(@statement.items.map(&:amount).reduce(:+)).to eq(@statement.amount_sum)
    end

    it "returns statement for nonactive currency (merchant - CHF)" do
      VCR.use_cassette 'statement_success_merchant_chf' do
        @statemnt = RubyPaypalNvp::Statement
          .where(date_from: Time.zone.parse('1.1.2017'),
                 date_to: Time.zone.parse('3.12.2017'),
                 subject: '2@zakaznik.com',
                 currency: 'CHF')
      end

      expect(@statement).to be_nil
    end
  end

  describe 'to_iis_json' do
    it 'returns UOL specific format of JSON' do
      VCR.use_cassette 'statement_success_json' do
        @statement = RubyPaypalNvp::Statement
          .where(date_from: Time.zone.parse('1.1.2017'),
                 date_to: Time.zone.parse('3.12.2017'),
                 subject: '1@zakaznik.com',
                 currency: 'CZK')
      end

      expect(@statement.to_iis_json)
        .to eq("{\"meta\":{\"timestamp\":\"2017-12-05T09:49:33Z\",\"start_date\":\"2016-12-31T23:00:00Z\",\"end_date\":"\
               "\"2017-12-03T22:59:59Z\",\"subject\":\"1@zakaznik.com\",\"currency_code\":\"CZK\"},\"values\":"\
               "[{\"L_TIMESTAMP\":\"2017-01-17T08:48:44Z\",\"L_TIMEZONE\":\"GMT\",\"L_TYPE\":\"Payment\",\"L_EMAIL\":"\
               "\"2@zakaznik.com\",\"L_NAME\":\"UOL ApiUser's Test Store\",\"L_TRANSACTIONID\":\"4G872000YA254271F\","\
               "\"L_STATUS\":\"Completed\",\"L_AMT\":\"64000.00\",\"L_CURRENCYCODE\":\"CZK\",\"L_FEEAMT\":\"0.00\","\
               "\"L_NETAMT\":\"64000.00\"},{\"L_TIMESTAMP\":\"2017-01-17T08:48:15Z\",\"L_TIMEZONE\":\"GMT\",\"L_TYPE\":"\
               "\"Payment\",\"L_EMAIL\":\"2@zakaznik.com\",\"L_NAME\":\"UOL ApiUser's Test Store\",\"L_TRANSACTIONID\":"\
               "\"8KM33168PJ5813642\",\"L_STATUS\":\"Completed\",\"L_AMT\":\"-1000.00\",\"L_CURRENCYCODE\":\"CZK\","\
               "\"L_FEEAMT\":\"0.00\",\"L_NETAMT\":\"-1000.00\"}]}")
    end
  end
end
