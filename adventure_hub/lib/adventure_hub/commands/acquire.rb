module AdventureHub
  module Commands
    class Acquire < Base
      def initialize(repo, source_path)
        super()
        @source_path = source_path
        @repo = repo
      end
      
      def perform
        info "scanning #{@source_path.realpath}"
        source_paths = SourceScanner.new(@source_path).scan
        total_size = source_paths.map(&:size).sum

        destination = @repo.get_incoming_path_for_source(total_size)

        source_dcim = @source_path + SourceScanner::DCIM
        info scan_summary(source_paths)

        destination_paths = source_paths.map{|f| destination + f.relative_path_from(source_dcim)}

        sources_and_destinations = source_paths.zip(destination_paths)
        copy = CopyBatch.new

        sources_and_destinations.each do |source, destination|
          destination.parent.mkpath
          # debug "#{source} => #{destination}"
          copy.cp source, destination.realdirpath
        end
        total_size = copy.total_size

        add_child copy
        wait_for_children

        info "Initial copy complete (#{total_size} bytes imported)..."
        info "Deleting from source"


        info "Acquisition complete"
      end


      private
      def scan_summary(files)
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
    end
  end
end
