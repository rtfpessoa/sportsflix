module Sportsflix
  module Utils
    class Executor

      def initialize(options)
        @verbose = options[:verbose]
      end

      def run(cmd)
        puts "[Running] #{cmd}" if @verbose
        output = `#{cmd}`
        {
            :output   => output,
            :success? => $?.success?,
        }
      end

    end
  end
end
