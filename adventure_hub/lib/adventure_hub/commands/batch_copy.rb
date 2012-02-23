module AdventureHub
  module Commands
    class BatchCopy < Base
      CONCURRENCY = 5

      def initialize
        super
        @cps = []
        @progress = {}
      end
      
      def cp(source, destination)
        @cps << add_child(:SingleCopy, source, destination)
      end
      
      def perform
        wait_for_children
      end
      
      def receive_report(command, type, value)
        if type == :progress
          @progress[command] = value
          report :progresses, @progress
        else
          super
        end
      end
      
    end
  end
end
