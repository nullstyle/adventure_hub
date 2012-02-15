module AdventureHub
  module Commands
    class Acquire
      def initialize(path)
        @path = path
      end
      
      def run
        puts "acquiring #{@path.realpath}"
      end
    end
  end
end
