module AdventureHub
  module Commands
    class Watch < Base
      
      def initialize(repo)
        super()
        @search_base = Pathname.new Platforms.current::MOUNT_POINT
        @repo = repo
      end

      def perform
        @previous_tick_sources = []
        
        loop do
          current_sources = find_sources
          new_sources = current_sources - @previous_tick_sources

          new_sources.each do |source|
            add_child Acquire.new(@repo, source)
          end

          @previous_tick_sources = current_sources
          sleep 1
        end
      end
      
      private
      def find_sources
        @search_base.children.select{|dir| SourceScanner.source? dir }
      rescue Errno::EACCES
        retry
      end


    end
  end
end
