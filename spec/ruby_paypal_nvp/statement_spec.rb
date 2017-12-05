RSpec.describe RubyPaypalNvp::Statement do
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
