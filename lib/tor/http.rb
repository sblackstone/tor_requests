require 'net/http'
require 'socksify/http'

module Tor

  class HTTP

    def self.get(uri_or_host, path = nil, port = nil)
      res = ""
      host = nil
      if path
        host = uri_or_host
      else
        host = uri_or_host.host
        port = uri_or_host.port
      end
      Net::HTTP.SOCKSProxy(Tor.configuration.ip, Tor.configuration.port).start(host, port) do |http|
        request = Net::HTTP::Get.new(path || uri_or_host.path)
        Tor.configuration.headers.each do |header, value|
          request.delete(header)
          request.add_field(header, value)
        end
        
        res = http.request(request);
      end
      res
    end
  
    def self.post(uri_or_host, post_options = {}, path = nil, port = nil)
      res = ""
      host = nil
      if path
        host = uri_or_host
      else
        host = uri_or_host.host
        port = uri_or_host.port
        path = uri_or_host.request_uri
      end

      Net::HTTP.SOCKSProxy(Tor.configuration.ip, Tor.configuration.port).start(host, port) do |http|
        request = Net::HTTP::Post.new(path)
        request.set_form_data(post_options)
        Tor.configuration.headers.each do |header, value|
          request.delete(header)
          request.add_field(header, value)
        end
        res = http.request(request)
      end
      res
    end

  end

end
   
