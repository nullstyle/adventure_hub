module Celluloid
  class Mailbox

    def length
      @mutex.lock
      begin
        @messages.length
      ensure
        @mutex.unlock
      end
    end

    def empty?
      length == 0
    end

  end
end