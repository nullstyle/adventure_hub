require 'multi_json'
require 'time'

module AdventureHub
  class Identifier
    MOVIE_EXTENSIONS = %w( mov mp4 avi )
    GPS_EXTENSIONS = %w( nmea )
    PHOTO_EXTENSIONS = %w( jpeg jpg nef rw2 png )


    def self.identify(input_path)    
      extension = input_path.extname[1..-1].downcase
      
      case extension
      when *MOVIE_EXTENSIONS ; return :movie
      when *PHOTO_EXTENSIONS ; return :photo
      end

      :unknown
    end
  end
end
