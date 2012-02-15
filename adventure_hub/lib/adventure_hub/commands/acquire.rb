module AdventureHub
  module Commands
    class Acquire
      def initialize(path)
        @path = path
      end
      
      def run
        AH.log "acquiring #{@path.realpath}"
        
        raise "Not a source!" unless Acquirer.source?(@path)
        
        Acquirer.new(@path).acquire do |type, source_file|
          AH.log "found #{type.inspect}: #{source_file.realpath}"
        end
        

      end
    end
  end
end
