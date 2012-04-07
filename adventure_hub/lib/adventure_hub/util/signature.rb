require 'digest/sha1'

module AdventureHub
  module Util
    module Signature
      MEGABYTE_LESS_ONE_KILOBYTE = (1024 * 1024) - 1024
      def quick_signature(files)

        content_lines = files.sort.map do |file|
          "#{file.size}:#{signature_blocks(file)}"
        end.join("\n")

        Digest::SHA1.hexdigest(content_lines)
      end

      def signature_blocks(file)
        blocks = []
        file.open("r") do |file|
          until file.eof?
            blocks << Digest::SHA1.hexdigest(file.read(1024))
            file.seek(MEGABYTE_LESS_ONE_KILOBYTE, IO::SEEK_CUR)
          end
        end
        blocks.join
      end

      extend self
    end
  end
end