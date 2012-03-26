module AdventureHub
  class Repository

    ##
    # Watches for new mounted disks
    #
    class DiskWatcher
      include Celluloid
      include Util::Eventing
      
      def initialize(runner)
        @runner = runner
        @previous_disks = load_disk_info
        after(1.0){ run }
      end


      private
      def run

        loop do
          current_disks = load_disk_info
          previous_devices = @previous_disks.keys
          current_devices = current_disks.keys
          
          added_devices   = current_devices - previous_devices
          removed_devices = previous_devices - current_devices

          #TODO: send the disk info with the event
          emit(:disks_changed, added:added_devices, removed:removed_devices) if added_devices.any? || removed_devices.any?

          @previous_disks = current_disks
          sleep 1
        end
      end

      def load_disk_info
        Util::DiskInfo.new(@runner).data
      end
    end
  end
end