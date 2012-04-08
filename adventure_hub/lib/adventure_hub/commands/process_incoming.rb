module AdventureHub
  module Commands

    class ProcessIncoming < Base
      GPS = Pathname.new("GPSFILES")

      def initialize(repo, path. clear=false)
        super()
        @repo = repo
        @path = path
      end
      
      def perform
        make_commands = []

        # import files from the AMOD GPS tracker
        gps_path = @path + GPS
        if gps_path.exist?
          gps_path.walk{|p| make_commands << Make::Gps.new(@repo, p) }
        end

        resource_summary = make_commands.summarize{|make| make.actor_class_name.split("::").last}

        info resource_summary

        make_commands.each{|make| add_child(make) ; wait_for_children}
        
        # delete incoming folder directory

        @path.rmtree if clear
          
      end

    end
  end
end
