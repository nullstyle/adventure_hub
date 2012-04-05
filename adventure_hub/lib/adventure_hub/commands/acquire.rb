module AdventureHub
  module Commands
    class Acquire < Base
      def initialize(repo, source_path)
        super()
        @source_path = source_path
        @scanner = SourceScanner.new(@source_path)
        @repo = repo
      end
      
      def perform
        info "scanning #{@source_path.realpath}"
        source_paths = @scanner.scan
        total_size = source_paths.map(&:size).sum
        info @scanner.summary

        destination = @repo.get_incoming_path_for_source(total_size)

        source_dcim = @source_path + SourceScanner::DCIM

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

        # TODO: register incoming folder with repo
        # repo.register_import destination
        info "Acquisition complete"
      end


      private

    end
  end
end
