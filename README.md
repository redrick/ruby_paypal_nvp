# RubyPaypalNvp

Missing paypal account statements.

As per communication with PayPal this is apart from PDF and CSV reports
prefered way of downloading e.x. monthly statements if you have too much and
need to automate the process...

This gem provides you with simple access to specific subject account statement.

## Requirements

- PayPal account of course
- Paypal credentials for NVP API can be found under:
  - Login on http://paypal.com/
  - Go to your Profile and settings (upper right corner menu)
  - Click on My selling tools
  - Under first part - Selling online - click on Update API access
  - At the bottom look up NVP/SOAP APIintegration (Classic)
  - Click Manage API credentials there
  - Finally after a while on this page is information needed for you to access
    NVP API data
- If you take care of multiple account data like we do, They need to give
  you access like this:
  - Login on http://paypal.com/
  - Click Profile“ → „Profile and settings“
  - In the menu choose „My selling tools“ and then „API access“ and click on Update
  - Choose the first option and click on „Add or edit API permissions“
  - On the next page „Add a new third party“
  - In the new window fill in ID given to you (is the one from previous part) and click „Lookup“
  - When the ID was filled in correctly a new menu with permissions will appear („Available Permissions“).
  - Choose the following options:
    - Obtain your PayPal account balance.
    - Obtain information about a single transaction.
    - Search your transactions for items that match specific criteria and display the results.
  - Confirm the selection by clicking „Add“.

And after these couple days of setup you are all good to go :)

Important to note here is that in first part is your account and setup and
stuff...

Second part is you customer (in our case) who wants you to lookup data for them
and they use your id that you need to send them (is always in email like form
without @ in it)

Then the `subject` used in search for statements is their email through which
they granted API access to you...

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby_paypal_nvp'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_paypal_nvp

## Usage

For the time being this gem provides you with Stamtement download for desired
period.

The weird PayPal pagin and all things considered proven to be correct input for
accountants to work with.

first step is configuration (either as initializer or if you have it in single
script or so):

```ruby
RubyPaypalNvp.configure do |config|
  config.user = 'YOUR_USER_HERE' # watch out may differ according to setup for sandbox
  config.password = 'YOUR_PWD_HERE'
  config.signature = 'YOUR_SIGNATURE_HERE'
  config.api_url = 'https://api-3t.paypal.com/nvp' # or put 'https://api-3t.andbox.aypal.com/nvp' for sandbox env
end
```

Then you are ready to query PayPal

We provide you with Statement class:

```
RubyPaypalNvp::Statement
```

Provides search method `where`:

```
RubyPaypalNvp::Statement.where(
  date_from: Time.zone.parse('1.9.2017'),
  date_to: Time.zone.parse('1.9.2017'),
  subject: 'info@uol.cz',
  currency: 'CZK',
  transaction_class: 'BalanceAffecting'
)
```

Where
- `date_from` beginning of interval to search for (beggining of the day - disregards time)
- `date_to` end of interval to search for (end of the day - disregards time)
  - Dates and times in particular are converted to utc
- `subject` is account email you are looking through (as per description in requirements)
- `currency` is as name says currency of desired account (defaults to `CZK`)
- `transaction_class` is per description found in docs (here)[https://developer.paypal.com/docs/classic/api/merchant/TransactionSearch_API_Operation_NVP/] defaults to `BalanceAffecting`
  - most problematic since multiple options you should be able to put the as `All` or `Received` result in `500` from PayPal which we are not able to identify (talking here about accounts with 1k+ transactions monthly)
  - default setup is provide to be stable and correct for accounting

Response you get from search is in form of Object containing:

```ruby
#<RubyPaypalNvp::Model::Statement:0x007fe4360ac450
 @amount_sum=1000.00,
 @currency_code="CZK",
 @end_date="2017-09-01T21:59:59Z",
 @fee_amount_sum=10.00,
 @items=
  [#<RubyPaypalNvp::Model::Item:0x007fe43679bf90
    @amount=1000.00,
    @currency_code="CZK",
    @email="test@uol.cz",
    @fee_amount=10.00,
    @name="Martin Tester",
    @net_amount=1010.00,
    @status="Completed",
    @timestamp="2017-09-01T12:48:08Z",
    @timezone="GMT",
    @transaction_id="9XXXXXXXXXXXXXXXH",
    @type="Refund">],
 @items_count=4,
 @net_amount_sum=1010.00,
 @start_date="2017-08-31T22:00:00Z",
 @subject="info@uol.cz",
 @timestamp="2017-11-02T10:45:07Z">
```

You can see all the sums and all items which represent all movements on the account in given time period there.

Also `RubyPaypalNvp::Model::Statemnt` result class from query provides you method `#generate_csv` which will create CSV from the data for inspection:

```
result = RubyPaypalNvp::Statement.where(
  date_from: Time.zone.parse('1.9.2017'),
  date_to: Time.zone.parse('30.9.2017'),
  subject: 'info@uol.cz',
  currency: 'CZK',
  transaction_class: 'BalanceAffecting'
)
result.generate_csv('location_to_save.csv')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ruby_paypal_nvp. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## TODO

Pending things that will be done shortly:
- Rspec

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RubyPaypalNvp project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/ruby_paypal_nvp/blob/master/CODE_OF_CONDUCT.md).
