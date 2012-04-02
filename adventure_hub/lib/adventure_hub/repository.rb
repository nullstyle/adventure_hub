require 'multi_json'
require 'time'
require 'fileutils'

module AdventureHub
  class Repository
    include Celluloid

    autoload :IncomingProcessor,  'adventure_hub/repository/incoming_processor'
    autoload :DiskWatcher,        'adventure_hub/repository/disk_watcher'

    REPO_FILE = Pathname.new("main.ahubrepo")
    attr_reader :mounted_disks

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
      DataMapper.setup(repo_dm_id, "sqlite:#{resource_db_path.expand_path}")
      DataMapper::Model.descendants.each do |model|
        model.auto_upgrade! repo_dm_id
      end

      activate

      @shell_runner = Util::ShellRunner.supervise.actor

      @mounted_disks = []

      populate_mounted_disks

      @disk_watcher = DiskWatcher.supervise(@shell_runner).actor
      @disk_watcher.on(:disk_added, current_actor, :disk_added!)
      @disk_watcher.on(:disk_removed, current_actor, :disk_removed!)



    end

    ##
    # Make this repo as the default DataMapper repo
    def activate
      DataMapper.setup(:default, "sqlite:#{resource_db_path.expand_path}")
    end

    def mounted?
      self.class.repository?(@base_path)
    end

    ##
    # Returns a path
    def get_incoming_path_for_source(needed_space)
      # find a disk with enough space

      raise "Cannot find a disk with enough space" unless disk

      incoming_path = disk.incoming_path

      # ensure unique directory by using a sequence
      sequence = -1
      begin
        sequence += 1
        proposed = incoming_path + "#{Time.now.to_i}.#{sequence}"
      end while proposed.exist?

      proposed.mkpath
      proposed
    end

    def resource_db_path
      @base_path + "resources.sqlite"
    end

    def disk_added(disk)
      if repo_disk = Models::Disk.retrieve(disk[:mount])
        @mounted_disks << repo_disk
      end
    end

    def disk_removed(removed_disk)
      @mounted_disks.delete_if{|disk| disk.mounted_path == removed_disk[:mount]}
    end

    private
    #returns the id under which the datamapper repository is registered
    def repo_dm_id
      @repo_dm_id ||= :"repo_#{self.object_id}"
    end

    def populate_mounted_disks
      disks = Util::DiskInfo.new(@shell_runner).data
      disks.values.each{|d|disk_added d}
    end

  end
end
