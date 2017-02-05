require 'sportsflix/players/proxies/acestream'
require 'sportsflix/players/proxies/default'
require 'sportsflix/utils/exec'

module Sportsflix
  module Players
    module VLC
      class Client

        ALTERNATIVE_PLAYER_PATHS = [
            'vlc',
            '/Applications/VLC.app/Contents/MacOS/VLC',
            '/c/Program Files/VideoLAN/VLC/vlc.exe',
            '/mnt/c/Program Files/VideoLAN/VLC/vlc.exe'
        ]

        def initialize(options)
          @verbose           = options[:verbose]
          @server_only       = options['server-only']
          @video_player_path = options['video-player-path']
          @proxy_delay       = options['proxy-delay']

          @executor       = Sportsflix::Utils::Executor.new(options)
          @stream_proxies = {
              :default   => Sportsflix::Players::Proxies::Default::Client.new(options),
              :acestream => Sportsflix::Players::Proxies::Acestream::Client.new(options)
          }
        end

        def start(stream)
          proxy = @stream_proxies[stream[:proxy]]

          proxy.stop
          proxy.start

          # Waiting for proxy to start
          puts "Waiting for proxy to start (#{@proxy_delay})..."
          sleep(@proxy_delay)

          unless @server_only
            video_player     = find_video_player
            stream_final_url = proxy.url(stream[:uri])

            puts "Playing #{stream_final_url}"
            @executor.run %{#{video_player} #{stream_final_url}}

            proxy.stop
          end
        end

        private
        def find_video_player
          unless which(@video_player_path) || File.exist?(@video_player_path)
            puts "Could not find video player #{@video_player_path}, searching for alternatives ..."

            ALTERNATIVE_PLAYER_PATHS.each do |path|
              if which(path) || File.exist?(path)
                puts "Found VLC player in #{path}"
                return path
              end
            end

            puts 'Could not find vlc in any of the alternative locations'
            exit(1)
          end

          @video_player_path
        end

        # Cross-platform way of finding an executable in the $PATH.
        # Source: http://stackoverflow.com/posts/5471032/revisions
        def which(cmd)
          exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
          ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
            exts.each { |ext|
              bin = File.join(path, "#{cmd}#{ext}")
              return File.executable?(bin) && !File.directory?(bin)
            }
          end

          false
        end
      end
    end
  end
end
