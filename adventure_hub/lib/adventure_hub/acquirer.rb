require 'pathname'

module AdventureHub
  class Acquirer
    DCIM = Pathname.new("DCIM")
    
    def self.source?(pathname)
      return false unless pathname.directory?
      
      !!pathname.children.detect{|p| p.directory? && p.basename == DCIM}
    end
    
    def initialize(path)
      @path = path
    end
    
    def acquire(&callback)
      dcim = (@path + "DCIM")
      dcfs = dcim.children.select(&:directory?)
      
      dcfs.each{|dcf| acquire_dcf dcf, callback}
      # identify source files
    end
    
    
    private
    def acquire_dcf(dcf, callback)
      AH.log "searching #{dcf.to_s}"
      dcf.children.each do |path|
        next if path.directory?
        
        type = Identifier.identify(path)
        callback.call type, path unless type == :unknown
      end
    end
  end
end
