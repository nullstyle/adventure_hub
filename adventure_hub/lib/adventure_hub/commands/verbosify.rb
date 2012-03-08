module AdventureHub
  module Commands
    class Verbosify < Base


      def initialize(child)
        super()
        @child = child
      end
      
      def perform
        add_child @child
        wait_for_children
      end
      
      def receive_report(command, type, value)
        info "#{type} => #{value.inspect}"
      end
    end
  end
end
