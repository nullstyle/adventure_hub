module AdventureHub
  module Models

    ##
    # Represents to information and tasks for a disk given to support adventure hub.
    # a disk given to adventure hub is dedicated to ahub use.
    class Disk
      include DataMapper::Resource

      property :uuid, UUID, :key => true
      property :last_known_available_space, Integer
      is :list
      default_scope(:default).update(:order => [:position.asc])

      before :valid?, :set_uuid
      before(:destroy){|disk|  throw :halt }  #disks cannot be deleted

      attr_accessor :mounted_path

      def self.retrieve(mounted_path)
        uuid_path = mounted_path + "adventures/uuid"
        return nil unless uuid_path.exist?
        uuid = uuid_path.read.strip

        disk = get(uuid)
        return nil unless disk

        disk.mounted_path = mounted_path
        disk.ensure_structure
        disk
      end

      ##
      # initializes the disk for use.  Creates the initial directory structure and
      # finds the total and available space, as well as creates the record in the db
      #
      def self.init(mounted_path)
        # make sure it's not a disk already

        disk = new
        disk.mounted_path = mounted_path

        raise ArgumentError, "Disk is already used by an ahub repo" if disk.uuid_path.exist?

        disk.save
        disk.ensure_structure
        disk
      end


      def mounted?
        self.mounted_path.present?
      end

      def base_path(stable=false)
        (stable ? Pathname.new(uuid.to_s) : @mounted_path) + "adventures"
      end

      def refresh_disk_info(runner)
        @disk_info = Util::DiskInfo.new(runner).info_for_path(base_path)
      end

      def uuid_path(stable=false)
        base_path(stable) + "uuid"
      end

      def incoming_path(stable=false)
        base_path(stable) + "incoming"
      end

      def resources_path(stable=false)
        base_path(stable) + "resources"
      end

      def available_space
        @disk_info[:available_size]
      end

      def total_space
        @disk_info[:total_size]
      end

      def ensure_structure
        base_path.mkpath
        uuid_path.open("w"){ |f| f.puts uuid } unless uuid_path.exist?
        resources_path.mkpath
        incoming_path.mkpath
      end

      private
      def set_uuid
        return unless self.uuid.blank?
        self.uuid = UUIDTools::UUID.timestamp_create
      end
    end
  end
end