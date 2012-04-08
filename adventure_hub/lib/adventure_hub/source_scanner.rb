require 'pathname'

module AdventureHub
  class SourceScanner
    DCIM = Pathname.new("DCIM")
    STEREO = Pathname.new("STEREO")
    GPSFILES = Pathname.new("GPSFILES")
    PRIVATE = Pathname.new("private")

    SOURCES = [DCIM, STEREO, GPSFILES, PRIVATE]

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
      search_bases = @possible_sources.select{|f| f.exist?}
      found = []
      search_bases.each do |search_base|
        search_base.walk{|p| found << p}
      end
      found
    end

    def summary
      files = scan
      extension_counts = files.summarize(&:extname)

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
