require "adventure_hub/version"

require 'pathname'
require 'adventure_hub/core_ext/object'
require 'active_support/core_ext/numeric'
require 'adventure_hub/core_ext/numeric'

require 'thor'
require 'celluloid'
require 'terminfo'
require 'adventure_hub/celluloid_ext/actor'
require 'adventure_hub/celluloid_ext/actor_proxy'
require 'adventure_hub/celluloid_ext/mailbox'


module AdventureHub
  autoload :Repository,     'adventure_hub/repository'
  autoload :Cli,            'adventure_hub/cli'
  autoload :Platforms,      'adventure_hub/platforms'
  autoload :SourceScanner,  'adventure_hub/source_scanner'
  autoload :Reporter,       'adventure_hub/reporter'
  autoload :Repl,           'adventure_hub/repl'


  autoload :CommandSystem,   'adventure_hub/command_system'

  module Commands
    autoload :Base,           'adventure_hub/commands/base'
    autoload :Verbosify,      'adventure_hub/commands/verbosify'
    autoload :Acquire,        'adventure_hub/commands/acquire'
    autoload :Watch,          'adventure_hub/commands/watch'
    autoload :CopyBatch,      'adventure_hub/commands/copy_batch'
    autoload :CopySingle,     'adventure_hub/commands/copy_single'
    autoload :IdentifySingle, 'adventure_hub/commands/identify_single'
  end

  module Servers
    autoload :Container,  'adventure_hub/servers/container'
    autoload :Base,       'adventure_hub/servers/base'
    autoload :Curate,     'adventure_hub/servers/curate'

  end

  module Util
    autoload :ShellRunner, "adventure_hub/util/shell_runner"
  end
  
  
  def self.setup
    Reporter.supervise_as :reporter
    CommandSystem.supervise_as :command_system

    Signal.trap("INT") do
      shutdown
    end
  end

  def self.shutdown
    puts "Shutting down..."
    @shutting_down = true
    Celluloid::Actor[:command_system].kill
  end

  def self.wait_for_actor(actor)
    return unless actor.actor?

    loop do
      if @shutting_down
        actor.terminate
      end
      break unless actor.alive?
      sleep 1
    end
  rescue => e
    exit
  end

end

AdventureHub.setup
AH = AdventureHub