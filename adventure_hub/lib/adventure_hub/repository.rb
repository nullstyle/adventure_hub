require 'multi_json'
require 'time'
require 'fileutils'

module AdventureHub
  class Repository
    include Celluloid

    def initialize(base_path)
      @base_path = base_path
    end

    ##
    # Returns a path
    def get_incoming_path_for_source
      sequence = 0
      base = @base_path + "incoming" + "#{Time.now.to_i}"

      proposed = incoming_path + "#{Time.now.to_i}.#{sequence}"
      while proposed.exist?
        sequence += 1
        proposed = incoming_path + "#{Time.now.to_i}.#{sequence}"
      end

      proposed.mkpath
      proposed
    end

    def clean_empty_incoming_dirs
      directories = incoming_path.children.select{|child| child.directory? && child.children.empty? }
      directories.map(&:rmdir)
    end

    
    def import(type, source_path)
      destination_path =  case type
                          when :movie ; categorize_movie(path)
                          end
                          
                          
    end


    private
    def incoming_path
      path = @base_path + "incoming"
      path.mkpath
      path
    end

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

  end
end
