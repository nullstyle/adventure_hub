require 'popen4'

module AdventureHub
  module Util
    class ShellRunner
      include Celluloid

      class Result < Struct.new(:stdout, :stderr, :status) ; end

      def run(command)
        require 'popen4'

        stdout, stderr = *[nil,nil]

        status = POpen4::popen4(command) do |out, err, stdin, pid|
          stdin.close
          stdout = out.read.strip
          stderr = err.read.strip
        end

        Result.new(stdout, stderr, status.exitstatus)
      end
    end
  end
end