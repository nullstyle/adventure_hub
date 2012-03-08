require 'popen4'

module AdventureHub
  module Util
    class ShellRunner
      include Celluloid

      def initialize(command)
        @command = command
        after(0.1){ run }
      end

      def stdout
        run
        @stdout
      end

      def stderr
        run
        @stderr
      end

      def run
        return if @ran
        require 'popen4'

        status = POpen4::popen4(@command) do |out, err, stdin, pid|
          stdin.close
          @stdout = out.read.strip
          @stderr = err.read.strip
        end

        @ran = true
      end
    end
  end
end