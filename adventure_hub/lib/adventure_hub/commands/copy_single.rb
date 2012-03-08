module AdventureHub
  module Commands
    class CopySingle < Base
      BLOCK_SIZE = 4096.kilobytes

      attr_reader :total_size

      def initialize(source, destination)
        super()
        @source = source
        @destination = destination

        @source_f = @source.open("r")
        @total_size = @source.size
      end
      
      def perform
        @source_f     = @source.open("r")
        out_file    = @destination.open("w")
        
        bytes_transferred = 0

        until bytes_transferred >= @total_size
          bytes_left  = (@total_size - bytes_transferred)
          to_read     = [bytes_left, BLOCK_SIZE].min

          buffer  = @source_f.sysread(to_read)
          out_file.syswrite(buffer)
          bytes_transferred += buffer.length

          report :progress, {
            source: @source,
            destination: @destination,
            current: bytes_transferred,
            total: @total_size
          }
        end
      end
      
      
    end
  end
end
