module AdventureHub
  module Commands
    module Make
      class Photo < Base

        def initialize(repo, files)
          super(repo)
          @files = files
        end
        
        def perform
          make_resource :photo
        end

      end
    end
  end
end
