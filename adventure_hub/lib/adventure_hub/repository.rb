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



    private
    def incoming_path
      path = @base_path + "incoming"
      path.mkpath
      path
    end

  end
end
