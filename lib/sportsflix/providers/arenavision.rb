require 'net/http'
require 'oga'

module Sportsflix
  module Providers
    module Arenavision
      class Client
        BASE_URLS = ['http://arenavision.in', 'http://arenavision.ru']
        BASE_URL  = BASE_URLS.sample

        def initialize(options)
          @verbose     = options[:verbose]
          @club_name   = options[:club]
          @server_only = options['server-only']
          @http        = Sportsflix::Utils::HTTP.new
        end

        def list_streams
          home          = get_page_contents("#{BASE_URL}/")
          schedule_path = home.css('a').select {|item| item.text.include?('EVENTS GUIDE')}.first.get('href')
          schedule      = get_page_contents("#{BASE_URL}#{schedule_path}")
          streams       = schedule.css('table tr')
          # Remove first element
          streams       = streams.drop(1)
          # Remove last element
          streams.pop(2)

          # Remove weird empty lines with non-breaking spaces ?!?
          streams = streams.select do |item|
            item_text = item.css('td:nth-child(1)').text
            item_text = item_text.force_encoding('UTF-8')
            item_text =item_text.delete(' ').strip
            not item_text.empty?
          end

          streams.map do |item|
            {
                :date        => clean_str(item.css('td:nth-child(1)').text),
                :hour        => clean_str(item.css('td:nth-child(2)').text),
                :sport       => clean_str(item.css('td:nth-child(3)').text),
                :competition => clean_str(item.css('td:nth-child(4)').text),
                :game        => clean_str(item.css('td:nth-child(5)').text),
                :stream_nr   => parse_stream_ids(clean_str(item.css('td:nth-child(6)').text)),
                :proxy       => :acestream
            }
          end
        end

        def get_stream_uri(stream_nr)
          stream_raw = get_page_contents("#{BASE_URL}/av#{stream_nr}")
          stream_raw.css('p[class="auto-style1"] a').first.get('href')
        end

        private
        def get_page_contents(raw_url)
          html_str = @http.get(raw_url, {}, {Cookie: 'beget=begetok;'}).body
          Oga.parse_xml(html_str)
        end

        def parse_stream_ids(raw_stream)
          matches = raw_stream.scan(/(([0-9]+)(?:-([0-9]+))? \[(.+?)\])/)
          matches.map do |match|
            {
                :start    => match[1].to_i,
                :end      => (match[2] || match[1]).to_i,
                :language => match[3]
            }
          end
        end

        def clean_str(str)
          str.force_encoding('UTF-8')
              .gsub("\n\t\t", ' ')
              .strip
        end

      end
    end
  end
end
