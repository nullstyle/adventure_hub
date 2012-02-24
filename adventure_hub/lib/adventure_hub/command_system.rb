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
      case type
      when :log;
        Celluloid::Actor[:reporter].log!([command.actor_class_name, type, value].inspect)
      when :progress;
        Celluloid::Actor[:reporter].progress!("#{command.actor_class_name}:#{command.pid}", value[:current], value[:total])
      when :lifecycle;
        Celluloid::Actor[:reporter].log!("#{value} #{command.actor_class_name}:#{command.pid}")
      end
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
      params = [actor.actor_class_name, :lifecycle]

      # no reason deaths are due to "terminate" messages
      params += reason ? [:crashed, reason] : [:terminated]

      Celluloid::Actor[:reporter].log! params.inspect
      @commands.delete actor
    end
  end
end
