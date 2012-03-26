module AdventureHub
  module Util
    module Metadata

      class Photo
        include Celluloid

        def extract(path, runner)
          json  = runner.run("exiftool -json #{path}").stdout
          data  = MultiJson.decode(json)
          exif  = data.first

          {
            exif: exif,
            occurred_at: Time.parse(exif["CreateDate"]),
          }
        end
      end

    end
  end
end