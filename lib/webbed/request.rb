require 'addressable/uri'

module Webbed
  class Request
    
    include GenericMessage
    attr_reader :request_uri
    
    def initialize(request_array)
      self.method       = request_array[0]
      self.request_uri  = request_array[1]
      self.http_version = request_array[2]
      self.headers      = request_array[3]
      self.entity_body  = request_array[4]
    end
    
    def method(*args)
      return super(*args) unless args.empty?
      @method
    end
    
    def method=(method)
      @method = Webbed::Method.new(method)
    end
    
    def request_uri=(uri)
      @request_uri = Addressable::URI.parse(uri)
    end
    
    def request_line
      "#{method} #{request_uri} #{http_version}\r\n"
    end
    alias :start_line :request_line
    
    # Helpers
    include Helpers::MethodHelper
    include Helpers::RequestUriHelper
    
  end
end