module AdventureHub
  module Commands
    class Watch < Base
      
      def initialize
        super
        @search_base = Pathname.new Platforms.current::MOUNT_POINT
      end

      def perform
        @previous_tick_sources = []
        
        i = 0
        loop do
          current_sources = find_sources
          new_sources = current_sources - @previous_tick_sources

          new_sources.each do |source|
            add_child(:Acquire, source)
          end

          @previous_tick_sources = current_sources
          raise "explide" if ( i+= 1 ) > 10
          sleep 1
        end
      end
      
      private
      def find_sources
        @search_base.children.select{|dir| Acquirer.source? dir }
      rescue Errno::EACCES
        retry
      end


    end
  end
end
