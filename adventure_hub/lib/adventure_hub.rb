require "adventure_hub/version"

require 'pathname'
require 'adventure_hub/core_ext/object'
require 'active_support/core_ext/numeric'
require 'adventure_hub/core_ext/numeric'
require 'adventure_hub/core_ext/pathname'
require 'active_support/core_ext/enumerable'
require 'adventure_hub/core_ext/enumerable'

require 'thor'
require 'celluloid'
require 'terminfo'
require 'data_mapper'
require 'dm-types'
require 'dm-constraints'
require 'dm-is-list'
require 'nokogiri'

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
    autoload :Base,             'adventure_hub/commands/base'
    autoload :Verbosify,        'adventure_hub/commands/verbosify'
    autoload :Acquire,          'adventure_hub/commands/acquire'
    autoload :Watch,            'adventure_hub/commands/watch'
    autoload :CopyBatch,        'adventure_hub/commands/copy_batch'
    autoload :CopySingle,       'adventure_hub/commands/copy_single'
    autoload :ProcessIncoming,  'adventure_hub/commands/process_incoming'

    module Make
      autoload :Base,   'adventure_hub/commands/make/base'
      autoload :Gps,    'adventure_hub/commands/make/gps'
      autoload :Photo,  'adventure_hub/commands/make/photo'
    end
  end

  module Models

    DataMapper.setup(:default, {:adapter => "in_memory"})
    require 'adventure_hub/models/disk'
    require 'adventure_hub/models/resource'
    require 'adventure_hub/models/sequence'
    require 'adventure_hub/models/file'
    DataMapper.finalize
  end

  module Servers
    autoload :Container,  'adventure_hub/servers/container'
    autoload :Base,       'adventure_hub/servers/base'
    autoload :Curate,     'adventure_hub/servers/curate'

  end

  module Util
    autoload :ShellRunner,  "adventure_hub/util/shell_runner"
    autoload :DiskInfo,     "adventure_hub/util/disk_info"
    autoload :Eventing,     "adventure_hub/util/eventing"
    autoload :Signature,    "adventure_hub/util/signature"

    module Metadata
      autoload :Photo,  "adventure_hub/util/metadata/photo"
      autoload :Video,  "adventure_hub/util/metadata/video"
      autoload :Avchd,  "adventure_hub/util/metadata/avchd"
      autoload :Gps,    "adventure_hub/util/metadata/gps"
    end
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