module Celluloid
  class ActorProxy

    def actor_class_name
      @klass
    end

    def address
      mailbox.address
    end

  end
end