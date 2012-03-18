module AdventureHub
  module Util
    module Metadata

      class Photo
        include Celluloid

        def extract(path)
          json    = Util::ShellRunner.new("exiftool -json #{path}").stdout
          data    = MultiJson.decode(json)
          
          exif = data.first
        end
      end

    end
  end
end