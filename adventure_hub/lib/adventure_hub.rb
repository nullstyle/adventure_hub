require "adventure_hub/version"

require 'pathname'
require 'active_support/core_ext/numeric'

require 'thor'
require 'fssm'


module AdventureHub
  autoload :Repository, 'adventure_hub/repository'
  autoload :Cli,        'adventure_hub/cli'
  autoload :Platforms,   'adventure_hub/platforms'
  autoload :Acquirer,   'adventure_hub/acquirer'

  module Commands
    autoload :Acquire,  'adventure_hub/commands/acquire'
    autoload :Watch,    'adventure_hub/commands/watch'
  end
end
