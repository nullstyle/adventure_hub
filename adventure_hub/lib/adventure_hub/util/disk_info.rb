
module AdventureHub
  module Util
    class DiskInfo
      attr_reader :data

      def initialize(runner)
        result = runner.run("df -k")

        raw = result.stdout.lines
        
        header = raw.first.split
        disk_lines = raw.drop(1).map{|line| line.split(/\s+/, 6)}

        
        @data = disk_lines.inject({}) do |result, disk|
          result[disk.first] = {
            device: disk.first,
            mount: Pathname.new(disk.last),
            total_size: disk[1].to_i * 1024,
            available_size: disk[3].to_i * 1024
          }
          result
        end

      end

      def info_for_path(path)
        # find the disk whose mount path contains the provided path and is the longest
        
        containing_disks = @data.find_all{|device, info| info[:mount].parent_of?(path)}.map(&:last)

        # find the longest mount point that contains the file
        containing_disks.sort{|l,r| l[:mount].expand_path.to_s.length <=> r[:mount].expand_path.to_s.length }.last
      end
    end
  end
end