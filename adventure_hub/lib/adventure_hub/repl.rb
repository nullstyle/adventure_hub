require 'ripl'

module AdventureHub
  class Repl
    attr_reader :repo

    def initialize(repo)
      @repo = repo
    end

    def start
      Ripl.start :binding => binding, :argv => []
    end

    private
    # runs a command and waits for the output
    def run(command)
      vebosifier = Commands::Verbosify.new(command)
      vebosifier.execute!
      AH.wait_for_actor(vebosifier)
    end

    def path(string)
      Pathname.new(string)
    end
  end
end
