module AdventureHub
  module Platforms
    autoload :OSX, "adventure_hub/platforms/osx"
    autoload :Linux, "adventure_hub/platforms/linux"
    
    def self.current
      @current ||= begin
        #TODO add any more platforms here
        case RUBY_PLATFORM
        when /darwin/
          OSX
        when /linux/
          Linux
        else
          raise "Unknown platform: #{RUBY_PLATFORM}"
        end
      end
    end
    
    
  end
end
