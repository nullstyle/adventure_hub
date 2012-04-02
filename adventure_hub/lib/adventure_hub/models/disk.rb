module AdventureHub
  module Models

    ##
    # Represents to information and tasks for a disk given to support adventure hub.
    # a disk given to adventure hub is dedicated to ahub use.
    class Disk
      include DataMapper::Resource


      property :uuid, UUID, :key => true
      property :last_known_available_space, Integer

      before :valid?, :set_uuid

      attr_accessor :mounted_path

      def self.retrieve(repo, mounted_path)
        uuid_path = mounted_path + "adventures/uuid"
        return nil unless uuid_path.exists?
        uuid = uuid.read.strip

        disk = get(uuid)
        disk.ensure_structure
        disk
      end

      ##
      # initializes the disk for use.  Creates the initial directory structure and
      # finds the total and available space, as well as creates the record in the db
      #
      def self.init(repo, mounted_path)
        # make sure it's not a disk already

        repo.with_repo do
          disk = new
          disk.mounted_path = mounted_path

          raise ArgumentError, "Disk is already used by an ahub repo" if disk.uuid_path.exist?

          p disk.save
          disk.ensure_structure
          disk
        end
      end


      def mounted?
        self.mounted_path.present?
      end

      def base_path
        @mounted_path + "adventures"
      end

      def refresh_disk_info
        @disk_info = Util::DiskInfo.new.info_for_path(base_path)
      end

      def uuid_path
        base_path + "uuid"
      end

      def sources_path
        base_path + "sources"
      end

      def derivatives_path
        base_path + "derivatives"
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
        sources_path.mkpath
        derivatives_path.mkpath
      end

      private
      def set_uuid
        self.uuid = UUIDTools::UUID.timestamp_create
      end
    end
  end
end