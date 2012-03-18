module AdventureHub
  class Repository
    # looks at an incoming folder and distills a list of operations to perform on the set to produce new assets
    class IncomingProcessor
      include Celluloid
      
      def initialize(repo)
        @repo = repo
      end

      def process(path)
        
      end
    end
  end
end