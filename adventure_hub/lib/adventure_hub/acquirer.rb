require 'pathname'

module AdventureHub
  class Acquirer
    DCIM = Pathname.new("DCIM")
    
    def self.source?(pathname)
      return false unless pathname.directory?
      
      !!pathname.children.detect{|p| p.directory? && p.basename == DCIM}
    end
  end
end
