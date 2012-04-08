module AdventureHub
  module Util
    module Metadata

      module Avchd
        DECIMAL_DURATION_FORMAT   = /^(\d+)\.(\d+) s$/
        TIMECODE_DURATION_FORMAT  = /^(\d):(\d\d):(\d\d)$/
        CREATE_DATE_FORMAT = "%Y:%m:%d %H:%M:%S"

        def extract(path, runner)
          ffprobe_json  = runner.run("ffprobe -v quiet -print_format json -show_streams #{path}").stdout
          data          = MultiJson.decode(ffprobe_json)
          video_stream  = data["streams"].find{|stream|  stream["codec_type"] == "video" }
          audio_stream  = data["streams"].find{|stream|  stream["codec_type"] == "audio" }


          exiftool_json = runner.run("exiftool -json #{path}").stdout
          data          = MultiJson.decode(exiftool_json).first

          occurred_at = begin
            created_at = DateTime.strptime(data["DateTimeOriginal"], CREATE_DATE_FORMAT)
            # shift to the current time zone
            now_offset = DateTime.now.offset
            (created_at - now_offset).new_offset(now_offset).to_time
          end

          raw_duration = data["Duration"]
          duration = if raw_duration =~ DECIMAL_DURATION_FORMAT
            (($1.to_i) * 60)  + $2.to_i
          elsif raw_duration =~ TIMECODE_DURATION_FORMAT
            (($1.to_i) * 60 * 60) + (($2.to_i) * 60) + $3.to_i
          else
            nil
          end

          {
            occurred_at:    occurred_at,
            duration:       duration,
            video_metadata: video_stream,
            audio_metadata: audio_stream,
            exif_metadata:  exiftool_json
          }
        end

        extend self
      end

    end
  end
end