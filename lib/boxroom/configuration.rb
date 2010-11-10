require 'rfc822'

module Boxroom
  
  class Configuration
    private
    class Error < RuntimeError;end

    DEFAULTS = {
      :user_may_change_username => true,
      :user_may_change_email => true,
      :use_search => true,
      :mailer_from_address => "boxroom@examlpe.com",
    }

    def self.method_missing(name, *args)
      if name.to_s =~ /\=$/
        set(name.to_s.chop.to_sym, args[0])
      elsif name.to_s =~ /\?$/
        get(name.to_s.chop.to_sym) == true
      else
        get(name)
      end
    end

    def self.set(name, value)
      raise Error, "Unknown config option '#{name}'!" unless DEFAULTS.has_key?(name)
      self.send("validate_#{name}", name, value) if self.respond_to?("validate_#{name}")
      DEFAULTS[name] = value
    end

    def self.get(name)
      raise Error, "Unknown config option '#{name}'!" unless DEFAULTS.has_key?(name)
      DEFAULTS[name]
    end

    def self.validate_mailer_from_address(name, value)
      raise Error, "#{name}: '#{value}' is not a valid email-address!" unless value =~ RFC822::EmailAddress 
    end

    def self.validate_search(name, value)
      raise Error, "#{name}: must be true or false" unless [true,false].include?(value)
    end

  end

  def self.config
    yield Configuration if block_given?
    Configuration
  end

end
