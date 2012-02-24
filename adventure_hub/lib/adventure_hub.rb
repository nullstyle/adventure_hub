require "adventure_hub/version"

require 'pathname'
require 'active_support/core_ext/numeric'

require 'thor'
require 'celluloid'
require 'terminfo'
require 'adventure_hub/celluloid_ext/actor'
require 'adventure_hub/celluloid_ext/actor_proxy'
require 'adventure_hub/celluloid_ext/mailbox'


module AdventureHub
  autoload :Identifier, 'adventure_hub/identifier'
  autoload :Repository, 'adventure_hub/repository'
  autoload :Cli,        'adventure_hub/cli'
  autoload :Platforms,  'adventure_hub/platforms'
  autoload :Acquirer,   'adventure_hub/acquirer'
  autoload :Reporter,   'adventure_hub/reporter'


  autoload :CommandSystem,   'adventure_hub/command_system'

  module Commands
    autoload :Base,       'adventure_hub/commands/base'
    autoload :Acquire,    'adventure_hub/commands/acquire'
    autoload :Watch,      'adventure_hub/commands/watch'
    autoload :BatchCopy,  'adventure_hub/commands/batch_copy'
    autoload :SingleCopy, 'adventure_hub/commands/single_copy'
  end
  
  
  def self.setup
    Reporter.supervise_as :reporter
    CommandSystem.supervise_as :command_system

    Signal.trap("INT") do
      shutdown
    end
  end

  def self.shutdown
    puts "shutting down"
    Celluloid::Actor[:command_system].kill
  end

  def self.wait_for_actor(actor)
    loop do
      break unless actor.alive?
      sleep 1
    end
  end

end

AdventureHub.setup
AH = AdventureHub