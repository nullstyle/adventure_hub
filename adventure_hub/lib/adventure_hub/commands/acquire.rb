module AdventureHub
  module Commands
    class Acquire < Base
      def initialize(path)
        super()
        @path = path
      end
      
      def perform
        info "acquiring #{@path.realpath}"
        
        raise "Not a source!" unless Acquirer.source?(@path)
        
        Acquirer.new(@path).acquire do |type, source_file|
          info "found #{type.inspect}: #{source_file.realpath}"
        end
        

      end
    end
  end
end
