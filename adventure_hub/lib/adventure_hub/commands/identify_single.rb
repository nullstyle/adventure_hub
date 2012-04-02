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
      AUDIO_EXTENSIONS = %w( wav mp3 aac )

      def initialize(path)
        super()
        @path = path
      end
      
      def perform
        type = get_type

        metadata = extract_base_metadata

        report :identification, type: type, metadata: metadata
      end


      private
      def get_type
        extension = @path.extname[1..-1].downcase
      
        case extension
        when *MOVIE_EXTENSIONS ; return :movie
        when *PHOTO_EXTENSIONS ; return :photo
        when *AUDIO_EXTENSIONS ; return :audio
        end

        :unknown
      end

      def extract_base_metadata
        {
          # md5: `openssl dgst -md5 #{@path.realpath}`.strip.split(" ").last, #hacky and dependent upon openssl output format.  oh well
          size: @path.size
        }
      end

    end
  end
end
