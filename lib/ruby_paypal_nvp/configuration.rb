module RubyPaypalNvp
  class Configuration
    attr_writer :version, :user, :password, :signature, :subject

    def initialize
      @version = nil
      @user = nil
      @password = nil
      @signature = nil
      @subject = nil
    end

    def version
      '204.0' unless @version
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
  end
end
