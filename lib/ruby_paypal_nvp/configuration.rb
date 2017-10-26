module RubyPaypalNvp
  class Configuration
    attr_writer :version, :user, :password, :signature, :subject, :api_url

    def initialize
      Time.zone = 'Prague'
      @version = nil
      @user = nil
      @password = nil
      @signature = nil
      @subject = nil
    end

    def version
      return '204.0' unless @version
      @version
    end

    def user
      raise ConfigNotSet, 'user' unless @user
      @user
    end

    def password
      raise ConfigNotSet, 'password' unless @password
      @password
    end

    def signature
      raise ConfigNotSet, 'signature' unless @signature
      @signature
    end

    def subject
      raise ConfigNotSet, 'subject' unless @subject
      @subject
    end

    def api_url
      raise ConfigNotSet, 'api_url' unless @api_url
      @api_url
    end
  end
end
