module AdventureHub
  module Commands
    class Acquire < Base
      def initialize(source_path)
        super()
        @source_path = source_path
      end
      
      def perform
        info "scanning #{@source_path.realpath}"
        files = SourceScanner.new(@source_path).scan

        info scan_summary(files)


        # start copy into incoming directory
      end


      private
      def scan_summary(files)
        extensions = files.map{|f| f.extname}
        extension_counts = {}
        extensions.each do |ext|
          extension_counts[ext] ||= 0
          extension_counts[ext] += 1
        end

        extension_counts.inject("") do |summary, ext_count|
          ext, count = *ext_count
          summary += "#{ext}\t\t#{count} files\r\n"
        end
      end
    end
  end
end
