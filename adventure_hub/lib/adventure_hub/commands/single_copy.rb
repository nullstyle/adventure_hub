module AdventureHub
  module Commands
    class SingleCopy < Base
      BLOCK_SIZE = 16.kilobytes

      def intiialize(source, destination)
        @source = source
        @destination = destination
      end
      
      
      def perform
        in_file     = @source.open("r")
        out_file    = @destination.open("w")
        in_size     = @source.size
        
        total       = 0

        begin
          to_read = (in_size - total) < BLOCK_SIZE ? (in_size - total) : BLOCK_SIZE
          buffer  = in_file.sysread(BLOCK_SIZE)
          out_file.syswrite(buffer)
          total += buffer.length
        end while total < in_size
      end
      
      
    end
  end
end
