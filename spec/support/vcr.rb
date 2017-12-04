require 'webmock/rspec'
require 'vcr'

WebMock.disable_net_connect!

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = false
  c.configure_rspec_metadata!
  c.hook_into :webmock
  c.cassette_library_dir = 'spec/cassettes'
  c.default_cassette_options = {
    match_requests_on: %i[method path query body]
  }
  c.before_record { |i| i.response.body.force_encoding 'UTF-8'  }
end
