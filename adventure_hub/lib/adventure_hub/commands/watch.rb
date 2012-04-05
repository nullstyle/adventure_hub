module AdventureHub
  module Commands
    class Watch < Base
      
      def initialize(repo)
        super()
        @repo = repo
      end

      def perform
        @previous_tick_sources = []
        @repo.disk_watcher.on(:disk_added, current_actor, :start_acquire!)

        info "Waiting for new sources..."
        
        loop do
          sleep 1
        end
      end

      def start_acquire(disk)
        mount = disk[:mount]
        if SourceScanner.source? mount
          add_child Acquire.new(@repo, mount)
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
