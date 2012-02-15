require "adventure_hub/version"

require 'pathname'
require 'active_support/core_ext/numeric'

require 'thor'
require 'fssm'
require 'celluloid'


module AdventureHub
  autoload :Identifier, 'adventure_hub/identifier'
  autoload :Repository, 'adventure_hub/repository'
  autoload :Cli,        'adventure_hub/cli'
  autoload :Platforms,  'adventure_hub/platforms'
  autoload :Acquirer,   'adventure_hub/acquirer'
  autoload :Reporter,   'adventure_hub/reporter'

  module Commands
    autoload :Acquire,  'adventure_hub/commands/acquire'
    autoload :Watch,    'adventure_hub/commands/watch'
  end
  
  
  def self.setup
    Reporter.supervise_as :reporter
  end
  
  def self.log(message)
    Celluloid::Actor[:reporter].log! message
  end
end

AdventureHub.setup
AH = AdventureHub