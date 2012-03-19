module AdventureHub
  module Models

    ##
    # Represents to information and tasks for a disk given to support adventure hub.
    # a disk given to adventure hub is dedicated to ahub use.
    class Disk
      attr_reader :uuid
      attr_reader :mounted_path

      ##
      # initializes the disk for use.  Creates the initial directory structure and
      # finds the total and available space.
      #
      def self.init(mounted_path, uuid)
        # make sure it's not a disk already
        disk = new(mounted_path)

        raise ArgumentError, "Disk is already used by an ahub repo" if disk.uuid_path.exist?

        disk.base_path.mkpath
        disk.uuid_path.open("w"){ |f| f.puts uuid }
        disk.sources_path.mkpath
        disk.derivatives_path.mkpath

        disk
      end

      def initialize(mounted_path)
        @mounted_path = mounted_path
        refresh_disk_info
      end

      def refresh_disk_info
        @disk_info = Util::DiskInfo.new.info_for_path(base_path)
      end

      def base_path
        @mounted_path + "adventures"
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

      def mounted?
        self.mounted_path.present?
      end

    end
  end
end