require 'thin'

module AdventureHub
  module Servers
    class Container
      include Celluloid
      
      def initialize(app)
        @app    = app
        @server = Thin::Server.new('0.0.0.0', 3000, @app, :signals => false)
        @dr = Util::DeathReaction.new_link
        @dr.add_reaction(current_actor, @server, :stop)
      end

      def run
        @server.start!
      rescue => e
        stop
      end

      def stop
        @server.stop!
        terminate
      end
    end
  end
end
