
module AdventureHub
  module Util
    module Eventing

      class ListenerRecord < Struct.new(:target, :handler, :multiplicity) ; end

      def on(event, target, handler)
        listeners[event] << ListenerRecord.new(target, handler, :many)
      end

      def once(event, target, handler)
        listeners[event] << ListenerRecord.new(target, handler, :once)
      end

      def remove_listener(event, target, handler)
        to_delete = listeners[event].select{|lr| lr.target == target && lr.handler == handler }
        listeners[event] -= to_delete
        to_delete.any?
      end

      private
      ##
      # @param [Symbol] event the event being emitted
      #
      def emit(event, *params)
        listeners_for_event = listeners[event]

        listeners_for_event.each{|lr| lr.target.send lr.handler, *params }
        listeners[event] -= listeners_for_event.select{|lr| lr.multiplicity == :once }
      end

      def listeners
        @listeners ||= Hash.new([])
      end
    end
  end
end