require 'pathname'

module AdventureHub
  class SourceScanner
    DCIM = Pathname.new("DCIM")
    
    def self.source?(pathname)
      return false unless pathname.directory?
      
      !!pathname.children.detect{|p| p.directory? && p.basename == DCIM}
    end
    
    def initialize(path)
      @path = path
    end
    
    def scan
      dcim = (@path + "DCIM")
      dcfs = dcim.children.select(&:directory?)
      
      dcfs.map{|dcf| scan_dcf dcf}.flatten
    end
    
    
    private
    def scan_dcf(dcf)
      dcf.children.select{|path| !path.directory? }
    end
  end
end
