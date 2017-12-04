RSpec.describe RubyPaypalNvp::Statement do
  it "returns statement for given search params" do
    expect(RubyPaypalNvp::VERSION).not_to be nil
    VCR.use_cassette 'statement_success' do
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
  end
end
