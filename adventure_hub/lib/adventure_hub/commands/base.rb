module AdventureHub
  module Commands
    ##
    # Commands form the back bone of the how adventure hub performs concurrent operations
    # by integrating celluloid and provided a general set of utilities to allow
    # integration and cooperation between tasks
    # 
    # Commands run as separate actors (i.e. in their own thread) and report on their 
    # status to their parent when run.
    #
    class Base
      include Celluloid
      attr_accessor :parent
      attr_reader   :children

      def initialize()
        @children = []
        @running = false
        @finished = false
      end
      
      def execute
        Celluloid::Actor[:command_system].add_command(current_actor)

        @running = true
        report :lifecycle, :start

        @children.each(&:execute!)

        perform

        @running = false
        @finished = true
        report :lifecycle, :finish
        report :lifecycle, :success

        Celluloid::Actor[:command_system].remove_command(current_actor)
        terminate
      end

      def running?
        @running
      end

      def perform()
        raise "implement in subclass"
      end

      def parent
        @parent || Celluloid::Actor[:command_system]
      end

      def receive_report(command, type, value)
        Celluloid::Actor[:command_system].receive_report!(command, type, value)
      end

      def add_child(type, *args)
        klass = Commands.const_get type
        klass.new_link(*args)
      end
        
      private
      def info(message)
        report :log, [:info, message]
      end

      def debug(message)
        report :log, [:debug, message]
      end

      def warn(message)
        report :log, [:warn, message]
      end

      def error(message)
        report :log, [:error, message]
      end

      def report(type, value)
        parent.receive_report!(current_actor, type, value)
      end

      def wait_for_children
        sleep(0.2) while @children.any?(&:alive)
      end
    end
  end
end
