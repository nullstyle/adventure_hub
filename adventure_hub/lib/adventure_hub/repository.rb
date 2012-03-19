require 'multi_json'
require 'time'
require 'fileutils'

module AdventureHub
  class Repository
    autoload :IncomingProcessor,  'adventure_hub/repository/incoming_processor'

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
      # @incoming = IncomingProcessor.supervise(current_actor)

      DataMapper.setup(repo_dm_id, "sqlite:#{resource_db_path.expand_path}")

      DataMapper::Model.descendants.each do |model|
        model.auto_upgrade! repo_dm_id
      end
    end

    def with_repo
       DataMapper.repository(repo_dm_id){ yield }
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

    def resource_db_path
      @base_path + "resources.sqlite"
    end

    private
    #returns the id under which the datamapper repository is registered
    def repo_dm_id
      @repo_dm_id ||= :"repo_#{self.object_id}"
    end


    def incoming_path
      path = @base_path + "incoming"
      path.mkpath
      path
    end

  end
end
