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
    autoload :BatchCopy,      'adventure_hub/commands/batch_copy'
    autoload :SingleCopy,     'adventure_hub/commands/single_copy'
    autoload :IdentifySingle, 'adventure_hub/commands/identify_single'
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