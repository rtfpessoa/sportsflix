require 'net/http'
require 'socket'
require 'sportsflix/players/vlc'
require 'sportsflix/providers/arenavision'
require 'sportsflix/utils/exec'

module Sportsflix
  class API

    def initialize(options)
      @verbose        = options[:verbose]
      @stream_offset  = options[:offset]
      @club_name      = options[:club]
      @no_interactive = options['no-interactive']
      @video_player   = options['video-player'].to_sym

      @arenavision_client = Providers::Arenavision::Client.new(options)
      @executor           = Sportsflix::Utils::Executor.new(options)
      @players            = {
          :vlc => Sportsflix::Players::VLC::Client.new(options)
      }
    end

    def watch
      streams = @arenavision_client.list_streams

      if @club_name
        streams = streams.select do |stream|
          stream[:game].downcase.include?(@club_name.downcase)
        end
      end

      response = ask_choose_stream(streams)

      stream_uri = @arenavision_client.get_stream_uri(response[:channel_number])

      unless @players.key?(@video_player)
        puts "Unable to find client for #{@video_player} player"
        exit(1)
      end

      player = @players[@video_player]
      player.start({
                       :proxy => response[:stream][:proxy],
                       :uri   => stream_uri
                   })
    end

    private
    def ask_choose_stream(streams)
      selection       = ask_stream(streams)
      selected_stream = streams[selection]

      stream_languages   = selected_stream[:stream_nr]
      language_selection = ask_language(stream_languages)

      stream_channels   = stream_languages[language_selection]
      stream_channel_nr = ask_channel(stream_channels)

      {
          :stream         => selected_stream,
          :channel_number => stream_channel_nr
      }
    end

    def ask_stream(streams)
      selection = 0
      if streams.empty?
        puts "There are no streams matching your query #{@club_name}"
        exit(1)
      elsif streams.length > 1 && !@no_interactive
        streams.each_with_index do |stream, idx|
          puts "#{idx}) #{stream[:game]}"
        end

        printf 'Choose the game: '
        selection = STDIN.gets.chomp.to_i
        puts ''
      end
      selection
    end

    def ask_language(stream_channels)
      channel_selection = 0
      if stream_channels.length > 1 && !@no_interactive
        stream_channels.each_with_index do |channel, idx|
          puts "#{idx}) #{channel[:language]}"
        end

        printf 'Choose the language: '
        channel_selection = STDIN.gets.chomp.to_i
        puts ''
      end
      channel_selection
    end

    def ask_channel(stream_channels)
      stream_channel_nr = stream_channels[:start]
      if stream_channels[:start] != stream_channels[:end] && !@no_interactive
        possible_channels = (stream_channels[:start]..stream_channels[:end]).to_a
        possible_channels.each_with_index do |nr, idx|
          if @stream_offset == idx
            puts "*#{idx}) Channel #{nr}"
          else
            puts " #{idx}) Channel #{nr}"
          end
        end

        printf 'Choose the channel number: '
        stream_channel_idx_raw = STDIN.gets.chomp
        puts ''

        begin
          stream_channel_offset = Integer(stream_channel_idx_raw)
        rescue ArgumentError
          stream_channel_offset = @stream_offset
        end
        stream_channel_nr = possible_channels[stream_channel_offset]
      end
      stream_channel_nr
    end

  end
end
