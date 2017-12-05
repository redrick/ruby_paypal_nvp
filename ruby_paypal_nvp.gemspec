lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_paypal_nvp/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby_paypal_nvp'
  spec.version       = RubyPaypalNvp::VERSION
  spec.authors       = ['Andrej Antas']
  spec.email         = ['andrej@antas.cz']

  spec.summary       = 'Ruby PayPal NVP wrapper'
  spec.description   = 'Ruby wrapper for PayPal NVP API since there was none'
  spec.homepage      = 'https://github.com/redrick/ruby_paypal_nvp'
  spec.license       = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org/'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activesupport', '~> 5.1'

  spec.add_development_dependency 'bundler', '~> 1.16.a'
  spec.add_development_dependency 'pry', '~> 0.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'vcr', '~> 2.2'
  spec.add_development_dependency 'webmock'
end
