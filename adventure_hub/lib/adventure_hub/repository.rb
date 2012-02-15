require 'multi_json'
require 'time'

module AdventureHub
  class Repository
    MOVIE_EXTENSIONS = %w( mov mp4 avi )
    GPS_EXTENSIONS = %w( nmea )

    def initialize(base_path)
      @base_path = base_path
    end

    def identify(input_path)
      case find_type(input_path)
      when :movie ;
        categorize_movie(input_path)
      when :unknown ;
        puts "could not categorize #{input_path}"
      end
    end

    private
    def categorize_movie(path)
      json = `ffprobe -v quiet -print_format json -show_streams #{path}`
      data = MultiJson.decode(json)

      stream = data["streams"].find{|stream|  stream["codec_type"] == "video" }

      start_date  = Time.parse(stream["tags"]["creation_time"])
      duration = stream["duration"].to_i

      "movies/#{start_date.iso8601} #{duration_s duration}#{File.extname(path).downcase}"
    end


    private
    def duration_s(seconds)
      hours   = seconds / 1.hour
      seconds -= hours * 1.hour
      minutes = seconds / 1.minute
      seconds -= minutes * 1.minute

      hours_s   = "#{hours}h"
      minutes_s = "#{minutes}m"
      seconds_s = "#{seconds}s"

      hours_s + minutes_s + seconds_s
    end

    def find_type(input_path)
      # search by extension
      
      extension = File.extname(input_path)[1..-1].downcase
      case extension
      when MOVIE_EXTENSIONS ; return :movie
      end

      :unknown
    end
  end
end
