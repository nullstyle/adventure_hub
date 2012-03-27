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

          added_devices.each  {|device| emit(:disk_added,   current_disks[device]) }
          removed_devices.each{|device| emit(:disk_removed, @previous_disks[device]) }
          
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