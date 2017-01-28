module Sportsflix
  module Players
    module Proxies
      module Default
        class Client

          def initialize(options)
            @verbose = options[:verbose]
          end

          def start
            puts 'Starting default proxy' if @verbose
          end

          def stop
            puts 'Stopping default proxy' if @verbose
          end

          def url(uri)
            uri
          end
        end
      end
    end
  end
end
