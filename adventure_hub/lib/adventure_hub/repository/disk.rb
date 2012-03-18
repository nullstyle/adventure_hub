module AdventureHub
  class Repository
    ##
    # 
    class Disk
      attr_reader :uuid
      attr_reader :available_space
      attr_reader :total_space
      attr_reader :mounted_path

      def mounted?
        self.mounted_path.present?
      end

      def incoming_path
        self.mounted_path + Pathname.new("/")
      end
    end
  end
end