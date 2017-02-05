require 'thor'
require 'sportsflix'

module Sportsflix

  class CLI < Thor

    # SLB, SLB, SLB, SLB, Glorioso SLB, Glorioso SLB !!!
    DEFAULT_TEAM              = 'BENFICA'
    DEFAULT_OFFSET            = 0
    DEFAULT_VIDEO_FORMAT      = 'mp4'
    DEFAULT_VIDEO_PLAYER      = 'vlc'
    DEFAULT_VIDEO_PLAYER_PATH = DEFAULT_VIDEO_PLAYER
    DEFAULT_PROXY_DELAY       = 10

    class_option('verbose', { :aliases => :vvv, :type => :boolean, :default => false })
    class_option('offset', { :aliases => :o, :type => :numeric, :default => DEFAULT_OFFSET })
    class_option('video-format', { :aliases => :f, :type => :string, :default => DEFAULT_VIDEO_FORMAT })
    class_option('club', { :aliases => :c, :type => :string })
    class_option('video-player', { :aliases => :p, :type => :string, :default => DEFAULT_VIDEO_PLAYER })
    class_option('video-player-path', { :aliases => :pp, :type => :string, :default => DEFAULT_VIDEO_PLAYER_PATH })
    class_option('no-interactive', { :aliases => :ni, :type => :boolean, :default => false })
    class_option('server-only', { :aliases => :s, :type => :boolean, :default => false })
    class_option('proxy-delay', { :aliases => :pd, :type => :number, :default => DEFAULT_PROXY_DELAY })

    desc('watch', 'watch stream in the chosen player')
    def watch
      api = API.new(options)
      api.watch
    end
  end
end
