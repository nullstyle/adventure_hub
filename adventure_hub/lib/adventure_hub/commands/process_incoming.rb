module AdventureHub
  module Commands
    ##
    # The identify single commands looks at a given file, determines it's overall type,
    # and then extracts out all metdata that is can find such as length, time of creation,
    # format, etc.
    # 
    class ProcessIncoming < Base
      def initialize(repo)
        super()
        @repo = repo
      end
      
      def perform
        # 
      end

    end
  end
end
