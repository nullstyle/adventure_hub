module AdventureHub
  module Util
    module Metadata

      module Photo
        def extract(path, runner)
          json  = runner.run("exiftool -json #{path}").stdout
          data  = MultiJson.decode(json)
          exif  = data.first

          {
            exif: exif,
            occurred_at: Time.parse(exif["CreateDate"]),
          }
        end
        extend self
      end
      
    end
  end
end