require 'thor'
require 'sportsflix'
require 'sportsflix/utils/http'

module Sportsflix

  class CLI < Thor

    # SLB, SLB, SLB, SLB, Glorioso SLB, Glorioso SLB !!!
    DEFAULT_TEAM              = 'BENFICA'
    DEFAULT_OFFSET            = 0
    DEFAULT_VIDEO_FORMAT      = 'mp4'
    DEFAULT_VIDEO_PLAYER      = 'vlc'
    DEFAULT_VIDEO_PLAYER_PATH = DEFAULT_VIDEO_PLAYER
    DEFAULT_PROXY_DELAY       = 10
    ACESTREAM_PROXY_IMAGES    = ['rtfpessoa/aceproxy:latest', 'ikatson/aceproxy:latest', 'zveronline/aceproxy:latest']

    class_option('verbose', {:type => :boolean, :default => false})
    class_option('offset', {:aliases => :o, :type => :numeric, :default => DEFAULT_OFFSET})
    class_option('video-format', {:aliases => :f, :type => :string, :default => DEFAULT_VIDEO_FORMAT})
    class_option('club', {:aliases => :c, :type => :string})
    class_option('video-player', {:aliases => :p, :type => :string, :default => DEFAULT_VIDEO_PLAYER})
    class_option('video-player-path', {:type => :string, :default => DEFAULT_VIDEO_PLAYER_PATH})
    class_option('interactive', {:type => :boolean, :default => false})
    class_option('server-only', {:aliases => :s, :type => :boolean, :default => false})
    class_option('proxy-delay', {:type => :numeric, :default => DEFAULT_PROXY_DELAY})
    class_option('server-ip', {:type => :string})
    class_option('acestream-proxy-image', {:type => :string, :default => ACESTREAM_PROXY_IMAGES[0], :enum => ACESTREAM_PROXY_IMAGES})

    desc('watch', 'watch stream in the chosen player')

    def watch
      api = API.new(options)
      api.watch
    end

  end
end
