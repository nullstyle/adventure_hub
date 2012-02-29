require 'multi_json'
require 'time'
require 'fileutils'

module AdventureHub
  class Repository
    include Celluloid

    REPO_FILE = Pathname.new("main.ahubrepo")

    def self.repository?(path)
      local_repo_file = path + REPO_FILE
      path.directory? && path.children.include?(local_repo_file)
    end

    def self.create(path)
      raise ArgumentError, "#{path} is already a repo!" if repository?(path)

      if path.exist? && !path.children.empty?
        raise ArgumentError, "#{path} is not empty!"
      end

      path.mkpath
      repo_file = path + REPO_FILE
      repo_file.open("w"){} #empty file

      # confirm the directory does not exist or is empty
      # raise error "Already a repo if the repo file exists"
      # create the directory if needed
      # write the ahubrepo file
      new(path)
    end

    def initialize(base_path)
      @base_path = base_path
    end

    def mounted?
      self.class.repository?(@base_path)
    end

    ##
    # Returns a path
    def get_incoming_path_for_source
      sequence = 0
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
