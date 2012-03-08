module AdventureHub
  module Commands
    ##
    # The identify single commands looks at a given file, determines it's overall type,
    # and then extracts out all metdata that is can find such as length, time of creation,
    # format, etc.
    # 
    class IdentifySingle < Base
      MOVIE_EXTENSIONS = %w( mov mp4 avi )
      GPS_EXTENSIONS = %w( nmea )
      PHOTO_EXTENSIONS = %w( jpeg jpg nef rw2 png )

      def initialize(path)
        super()
        @path = path
      end
      
      def perform
        type = get_type

        metadata = extract_base_metadata
        metadata.merge! self.send(:"extract_#{type}_metadata")


        report :identification, type: type, metadata: metadata
      end


      private
      def get_type
        extension = @path.extname[1..-1].downcase
      
        case extension
        when *MOVIE_EXTENSIONS ; return :movie
        when *PHOTO_EXTENSIONS ; return :photo
        end

        :unknown
      end

      def extract_unknown_metadata
        {}
      end

      def extract_base_metadata
        {
          # md5: `openssl dgst -md5 #{@path.realpath}`.strip.split(" ").last, #hacky and dependent upon openssl output format.  oh well
          size: @path.size
        }
      end

      def extract_movie_metadata
        json    = Util::ShellRunner.new("ffprobe -v quiet -print_format json -show_streams #{@path}").stdout
        data    = MultiJson.decode(json)
        stream  = data["streams"].find{|stream|  stream["codec_type"] == "video" }

        {
          started_at: Time.parse(stream["tags"]["creation_time"]),
          duration: stream["duration"].to_i
        }
      end

      def extract_photo_metadata
        # get creation time
        {}
      end

      def extract_gps_metadata
        # get creation time
        # get duration
        {}
      end
    end
  end
end
