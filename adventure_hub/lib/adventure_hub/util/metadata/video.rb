module AdventureHub
  module Util
    module Metadata

      class Video
        include Celluloid

        def extract(path)
          json    = Util::ShellRunner.new("ffprobe -v quiet -print_format json -show_streams #{@path}").stdout
          data    = MultiJson.decode(json)
          video_stream  = data["streams"].find{|stream|  stream["codec_type"] == "video" }
          audio_stream  = data["streams"].find{|stream|  stream["codec_type"] == "audio" }

          {
            occurred_at: Time.parse(video_stream["tags"]["creation_time"]),
            duration: video_stream["duration"].to_i,
            video_metadata: video_stream,
            audio_metadata: audio_stream
          }
        end
      end

    end
  end
end