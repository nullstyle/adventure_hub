module AdventureHub
  module Util
    module Metadata

      class Gps
        include Celluloid

        FORMAT_MAP = {
          ".log" => :nmea,
          ".gpx" => :gpx
        }

        def extract(path, runner)
          xml = Nokogiri::XML(get_gpx(path, runner))
          times = xml.search("trkpt > time").map{|t| Time.parse(t)}.sort
          {
            occurred_at:    times.first,
            duration:       (times.last - times.first).to_i,
          }
        end


        private
        def get_gpx(path, runner)
          format = format_for(path)
          if format != :gpx
            status = runner.run("gpsbabel -i #{format} -f #{path.expand_path.to_s} -o gpx -F -")
            status.stdout
          else
            path.read
          end
        end

        def format_for(path)
          FORMAT_MAP[path.extname]
        end
      end

    end
  end
end