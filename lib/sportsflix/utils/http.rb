require 'net/http'
require 'execjs'

module Sportsflix
  module Utils
    class HTTP

      DEFAULT_USER_AGENTS = [
          'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36',
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36',
          'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36',
          'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:46.0) Gecko/20100101 Firefox/46.0',
          'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:41.0) Gecko/20100101 Firefox/41.0',
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3099.0 Safari/537.36'
      ]

      DEFAULT_HEADERS = {
          'User-Agent' => DEFAULT_USER_AGENTS.sample
      }

      def initialize
        @headers = DEFAULT_HEADERS
        @params  = {}
      end

      def get(raw_url, extra_params = {}, extra_headers = {})
        uri       = URI.parse(raw_url)
        uri.query = URI.encode_www_form(@params.merge(extra_params))
        req       = Net::HTTP::Get.new(uri, @headers.merge(extra_headers))

        res = Net::HTTP.start(uri.hostname, uri.port) {|http|
          http.request(req)
        }

        get_lambda = lambda {|url| get(url, extra_params, extra_headers)}

        with_cf_bypass(res, get_lambda)
      end

      def post(raw_url, body, extra_params = {}, extra_headers = {})
        uri            = URI.parse(raw_url)
        uri.query      = URI.encode_www_form(@params.merge(extra_params))
        merged_headers = @headers
                             .merge({'Content-Type' => 'application/x-www-form-urlencoded'})
                             .merge(extra_headers)
        req            = Net::HTTP::Post.new(uri, merged_headers)

        res = Net::HTTP.start(uri.hostname, uri.port) {|http|
          http.request(req)
        }

        post_lambda = lambda {|url| post(url, body, extra_params, extra_headers)}

        bypassed_res = with_cf_bypass(res, post_lambda)
        bypassed_res.body
      end

      private
      def with_cf_bypass(res, req_lambda)
        if needs_cf_answer(res)
          url = "#{res.uri.scheme}://#{res.uri.hostname}:#{res.uri.port}/cdn-cgi/l/chk_jschl"

          @headers = @headers.merge({Referer: res.uri.to_s})
          @params  = @params.merge(
              {
                  jschl_vc:     /name="jschl_vc" value="(\w+)"/.match(res.body),
                  pass:         /name="pass" value="(.+?)"/.match(res.body),
                  jschl_answer: "#{solve_challenge(res.body)}#{res.hostname.size}"
              }
          )

          redirect = req_lambda.call(url)
          req_lambda.call(redirect['location'])
        else
          if res.is_a?(Net::HTTPRedirection)
            puts "Redirecting from #{res.uri} to #{res['location']}."
          end

          res
        end
      end

      def needs_cf_answer(res)
        res.is_a?(Net::HTTPServiceUnavailable) &&
            res['Server'] == 'cloudflare-nginx' &&
            res.body.include?('jschl_vc') &&
            res.body.include?('jschl_answer')
      end

      def solve_challenge(body)
        begin
          js = /setTimeout\(function\(\){\s+(var s,t,o,p,b,r,e,a,k,i,n,g,f.+?\r?\n[\s\S]+?a\.value =.+?)\r?\n/.match(body)
        rescue
          puts 'Unable to identify Cloudflare IUAM Javascript on website.'
          exit(1)
        end

        js = js.gsub("a\.value = (parseInt\(.+?\)).+", "\1")
        js = js.gsub("\s{3,}[a-z](?: = |\.).+", '')

        # Strip characters that could be used to exit the string context
        # These characters are not currently used in Cloudflare's arithmetic snippet
        js = js.gsub("[\n\\']", '')

        unless js.include?('parseInt')
          puts 'Error parsing Cloudflare IUAM Javascript challenge.'
          exit(1)
        end

        begin
          js     = "return require('vm').runInNewContext('#{js}');"
          result = ExecJS.eval(js)
        rescue
          puts 'Error executing Cloudflare IUAM Javascript.'
          exit(1)
        end

        begin
          result = result.to_i
        rescue
          puts 'Cloudflare IUAM challenge returned unexpected value.'
          exit(1)
        end

        result.to_s
      end

    end
  end
end
