module RubyPaypalNvp
  class Balance
    def self.where(options)
      ::RubyPaypalNvp::Fetcher::Balance.call(options)
    end
  end
end
