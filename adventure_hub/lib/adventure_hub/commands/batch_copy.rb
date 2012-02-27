module AdventureHub
  module Commands
    class BatchCopy < Base
      CONCURRENCY = 5

      attr_reader :total_size
      
      def initialize
        super
        @queued_commands = []
        @total_size = 0
        @running_commands = []
        @progress = {}
      end
      
      def cp(source, destination)
        command = SingleCopy.new(source, destination)
        @total_size += command.total_size
        @queued_commands << command
      end
      
      def perform
        queue_up_children
        wait_for_children
      end
      
      def receive_report(command, type, value)
        case type
        when :progress;
          @progress[command.pid] = value
          report :progresses, @progress
          report :progress, get_progress
        when :lifecycle;
          case value
          when :success;
            handle_finished_child command, true
          when :failure;
            handle_finished_child command, false
          else
            super
          end
        else
          super
        end
      end

      private
      def get_progress
        bytes_transferred = @progress.values.inject(0){|memo, progress| memo + progress[:current]}
        
        { current: bytes_transferred, total: @total_size }
      end

      def queue_up_children
        while @running_commands.length < CONCURRENCY
          return if @queued_commands.empty?

          @running_commands << add_child(@queued_commands.shift)
        end
      end

      def handle_finished_child(command, success)
        @running_commands.delete(command)
        queue_up_children
      end
      
    end
  end
end
