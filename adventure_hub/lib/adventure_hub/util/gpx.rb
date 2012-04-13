module AdventureHub
  module Util

    module Gpx

      def get_from_nmea(path, runner)
        status = runner.run("gpsbabel -i nmea -f #{path.shell_escape} -o gpx -F -")
        status.stdout
      end

      extend self
    end
  end
end