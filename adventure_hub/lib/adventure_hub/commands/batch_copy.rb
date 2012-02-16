module AdventureHub
  module Commands
    class BatchCopy < Base
      CONCURRENCY = 5

      def intiialize
        @cps = []
      end
      
      def cp(source, destination)
        @cps << [source, destination]
      end
      
      def perform

      end
      
      
    end
  end
end
