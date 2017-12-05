RSpec.describe RubyPaypalNvp::Balance do
  describe 'where' do
    it "returns balance for given search params (CZK)" do
      VCR.use_cassette 'balance_success_person' do
        @balance = RubyPaypalNvp::Balance
          .where(subject: '1@zakaznik.com',
                 currency: 'CZK')
      end

      expect(@balance.currency_code).to eq("CZK")
      expect(@balance.opening_balance).to eq(58221.0)
      expect(@balance.subject).to eq("1@zakaznik.com")
      expect(@balance.timestamp).to eq("2017-12-06 10:00:14 +0100")
    end
  end
end


