require 'pathname'

module AdventureHub
  class SourceScanner
    DCIM = Pathname.new("DCIM")
    STEREO = Pathname.new("STEREO")
    GPSFILES = Pathname.new("GPSFILES")

    SOURCES = [DCIM, STEREO, GPSFILES]

    def self.source?(path)
      return false unless path.directory?
      return true if SOURCES.any?{|s| path.has_child_dir?(s)}

      false
    end
    
    def initialize(path)
      @path = path
      @possible_sources = SOURCES.map{|s| @path + s }
    end
    
    def scan
      search_base = @possible_sources.find{|f| f.exist?}
      found = []
      search_base.walk{|p| found << p}
      found
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


    def get_files(dir)
      dir.children.select{|path| !path.directory? }
    end
  end
end
