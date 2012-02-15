require "adventure_hub/version"
require 'active_support/core_ext/numeric'

module AdventureHub
  autoload :Repository, 'adventure_hub/repository'
  autoload :Cli,        'adventure_hub/cli'

  module Commands
    autoload :Acquire, 'adventure_hub/commands/acquire'


  end
end
