require 'pathname'

module AdventureHub
  class SourceScanner
    DCIM = Pathname.new("DCIM")
    STEREO = Pathname.new("STEREO")
    
    def self.source?(pathname)
      return false unless pathname.directory?

      return true if dcim?(pathname)
      return true if stereo?(pathname)

      false
    end
    
    def initialize(path)
      @path = path
    end
    
    def scan
      search_base = (@path + "DCIM") if self.class.dcim?(@path)
      search_base ||= (@path + "STEREO") if self.class.stereo?(@path)

      dirs = search_base.children.select(&:directory?)
      
      dirs.map{|dir| get_files dir}.flatten
    end

    def summary
      files = scan
      extensions = files.map{|f| f.extname}
      extension_counts = {}
      extensions.each do |ext|
        extension_counts[ext] ||= 0
        extension_counts[ext] += 1
      end

      extension_counts.inject("Found #{files.length} files:\r\n") do |summary, ext_count|
        ext, count = *ext_count
        summary += "  #{ext.ljust(6)}#{count} files\r\n"
      end
    end
    
    
    private
    def self.dcim?(pathname)
      pathname.children.detect{|p| p.directory? && p.basename == DCIM}
    end

    def self.stereo?(pathname)
      pathname.children.detect{|p| p.directory? && p.basename == STEREO}
    end

    def get_files(dir)
      dir.children.select{|path| !path.directory? }
    end
  end
end
