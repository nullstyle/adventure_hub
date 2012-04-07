module AdventureHub
  module Commands
    module Make
      class Base < Commands::Base

        def initialize(repo)
          super()
          @repo = repo
          
        end
        

        private
        def make_resource(type)
          @resource = Models::Resource.create(:type => type)
        end

      end
    end
  end
end
