require 'sportsflix/utils/exec'

module Sportsflix
  module Players
    module Proxies
      module Acestream
        class Client

          ACESTREAM_STREAM_URI_PREFIX    = 'acestream://'
          ACESTREAM_PROXY_IMAGE_NAME     = ['ikatson/aceproxy', 'zveronline/aceproxy']
          ACESTREAM_PROXY_IMAGE_NAME_IDX = 0
          ACESTREAM_PROXY_DOCKER_NAME    = 'acestream'

          def initialize(options)
            @verbose      = options[:verbose]
            @video_format = options['video-format']

            @executor = Sportsflix::Utils::Executor.new(options)
          end

          def start
            @executor.run %{docker pull #{ACESTREAM_PROXY_IMAGE_NAME[ACESTREAM_PROXY_IMAGE_NAME_IDX]}}
            @executor.run %{docker run -d -t -p 8000:8000 --name #{ACESTREAM_PROXY_DOCKER_NAME} #{ACESTREAM_PROXY_IMAGE_NAME[ACESTREAM_PROXY_IMAGE_NAME_IDX]}}
          end

          def stop
            @executor.run %{docker rm -f #{ACESTREAM_PROXY_DOCKER_NAME}}
          end

          def url(uri)
            stream_uuid = uri.sub(ACESTREAM_STREAM_URI_PREFIX, '')
            machine_ip  = local_ip
            "http://#{machine_ip}:8000/pid/#{stream_uuid}/stream.#{@video_format}"
          end

          private
          def local_ip
            # Turn off reverse DNS resolution temporarily
            orig                         = Socket.do_not_reverse_lookup
            Socket.do_not_reverse_lookup = true

            begin
              UDPSocket.open do |s|
                # Google
                s.connect '64.233.187.99', 1
                s.addr.last
              end
            rescue
              return '127.0.0.1'
            end
          ensure
            # Restore DNS resolution
            Socket.do_not_reverse_lookup = orig
          end
        end
      end
    end
  end
end
