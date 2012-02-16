module AdventureHub
  class CommandSystem
    include Celluloid
    trap_exit :actor_died

    def initialize
      @commands = []
    end

    def kill
      @commands.each(&:terminate)
    end
    
    def receive_report(command, type, value)
      AH.log([command.class.name, type, value].inspect)
    end

    def wait_until_exit
      loop do
        break if @commands.empty?
        sleep(1)
      end
    end

    def add_command(command)
      link(command)
      @commands << command
    end

    def remove_command(command)
      @commands.delete command
      unlink(command)
    end

    def actor_died(actor, reason)
      if reason
        AH.log([actor.actor_class_name, :lifecycle, :crashed, reason].inspect)
      else
        AH.log([actor.actor_class_name, :lifecycle, :terminated].inspect)
      end
      @commands.delete actor
    end
  end
end
