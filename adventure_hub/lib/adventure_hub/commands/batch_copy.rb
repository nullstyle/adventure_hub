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
          @progress[command.pid] = value
          report :progresses, @progress
          report :progress, get_progress
        else
          super
        end
      end

      private
      def get_progress
        bytes_transferred = @progress.values.inject(0){|memo, progress| memo + progress[:current]}
        bytes_total = @progress.values.inject(0){|memo, progress| memo + progress[:total]}

        { current: bytes_transferred, total: bytes_total }
      end
      
    end
  end
end
