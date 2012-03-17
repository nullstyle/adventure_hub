module Celluloid
  class ActorProxy

    def actor_class_name
      @klass
    end

    def actor?
      true
    end

    def pid
      mailbox.address
    end

  end
end