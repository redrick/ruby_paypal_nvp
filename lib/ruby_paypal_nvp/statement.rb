module RubyPaypalNvp
  class Statement
    def self.where(options)
      ::RubyPaypalNvp::Fetcher::Statement.call(options)
    end
  end
end
