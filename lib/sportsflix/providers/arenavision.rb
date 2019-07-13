require 'net/http'
require 'oga'

module Sportsflix
  module Providers
    module Arenavision
      class Client
        BASE_URLS = ['http://arenavision.in', 'http://arenavision.biz', 'http://arenavision.us']

        HEADERS = {
            'Cookie': 'beget=begetok;',
            'User-Agent': 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:65.0) Gecko/20100101 Firefox/65.0',
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
            'Accept-Language': 'en-GB,pt;q=0.5',
            'DNT': '1',
            'Connection': 'keep-alive'
        }

        def initialize(options)
          @verbose = options[:verbose]
          @club_name = options[:club]
          @server_only = options['server-only']
          @http = Sportsflix::Utils::HTTP.new
          @base_url = BASE_URLS.sample
          puts ""
          puts @base_url
          puts ""
        end

        def list_streams
          @base_url = resolve_base_url("#{@base_url}/")
          home = get_page_contents("#{@base_url}/")
          schedule_path = home.css('a').select {|item| item.text.include?('EVENTS GUIDE')}.first.get('href')
          schedule_url = if schedule_path.start_with?("http")
                           schedule_path
                         else
                           "#{@base_url}#{schedule_path}"
                         end
          schedule = get_page_contents(schedule_url)
          streams = schedule.css('table tr')
          # Remove first element
          streams = streams.drop(1)
          # Remove last element
          streams.pop(2)

          # Remove weird empty lines with non-breaking spaces ?!?
          streams = streams.select do |item|
            item_text = item.css('td:nth-child(1)').text
            item_text = item_text.force_encoding('UTF-8')
            item_text = item_text.delete(' ').strip

            script_text = item.css('td:nth-child(1) script').text

            not item_text.empty? and script_text.empty?
          end

          streams.map do |item|
            {
                :date => clean_str(item.css('td:nth-child(1)').text),
                :hour => clean_str(item.css('td:nth-child(2)').text),
                :sport => clean_str(item.css('td:nth-child(3)').text),
                :competition => clean_str(item.css('td:nth-child(4)').text),
                :game => clean_str(item.css('td:nth-child(5)').text),
                :stream_nr => parse_stream_ids(clean_str(item.css('td:nth-child(6)').text)),
                :proxy => :acestream
            }
          end
        end

        def get_stream_uri(stream_nr, event)
          home = get_page_contents("#{@base_url}/")
          stream_link = home.css('a').select {|item| item.text.include?("#{event} #{stream_nr}")}.first.get('href')
          stream_raw = get_page_contents(stream_link)
          stream_raw.css('a').select {|item| !item.get('href').nil? && item.get('href').include?('acestream://')}.first.get('href')
        end

        private

        def resolve_base_url(raw_url)
          resp = @http.get(raw_url, {},HEADERS)
          "#{resp.uri.scheme}://#{resp.uri.host}"
        end

        def get_page_contents(raw_url)
          html_str = @http.get(raw_url, {}, HEADERS).body
          Oga.parse_xml(html_str)
        end

        def parse_stream_ids(raw_stream)
          matches = raw_stream.scan(/(([W]?[0-9]+)(?:-([W]?[0-9]+))? \[(.+?)\])/)
          matches.map do |match|
            {
                :start => match[1].delete("W").to_i,
                :end => (match[2] || match[1]).delete("W").to_i,
                :language => match[3],
                :event => if match[1].start_with?("W")
                            "World Cup"
                          else
                            "ArenaVision"
                          end
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
