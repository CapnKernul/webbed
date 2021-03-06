module Webbed
  # Representation of an HTTP Response.
  # 
  # This class contains the absolute minimum for accessing the different parts
  # of an HTTP Response. Helper modules provide far more functionality.
  class Response
    include GenericMessage
    
    STATUS_CODE_REGEX = /^(\d{3}) (.*)$/
    
    # The Status Code of the Response.
    # 
    # The method automatically converts the new value to an instance of
    # {Webbed::StatusCode} if it is not already one.
    # 
    # @return [#to_i]
    attr_reader :status_code
    
    def status_code=(status_code)
      @status_code = Webbed::StatusCode.lookup(status_code)
    end
    
    # The Reason Phrase of the Response.
    # 
    # The method returns the Status Code's default reason phrase if the Reason
    # Phrase has not already been set.
    # 
    # @return [String]
    def reason_phrase
      defined?(@reason_phrase) ? @reason_phrase : @status_code.default_reason_phrase
    end
    
    attr_writer :reason_phrase
    
    # Creates a new Response.
    # 
    # The Status Code may be passed in as a string with a Reason Phrase or just
    # a number. If a number is provided, the default Reason Phrase for that
    # Status Code is used.
    # 
    # The method converts the values passed in to their proper types.
    # 
    # @example
    #     Webbed::Response.new(200, {}, '')
    #     Webbed::Response.new('404 Missing File', {}, '')
    # 
    # @param [Fixnum, String] status_code
    # @param [Webbed::Headers, Hash] headers
    # @param [#to_s] entity_body
    # @param [Array] options the options to create the Response with @option
    # @options options [#to_s] :http_version (1.1) the HTTP Version of the Response
    def initialize(status_code, headers, entity_body, options = {})
      if STATUS_CODE_REGEX =~ status_code.to_s
        self.status_code = $1
        self.reason_phrase = $2
      else
        self.status_code = status_code
      end
      
      self.headers = headers
      self.entity_body = entity_body
      
      self.http_version = options.fetch(:http_version, 1.1)
    end
    
    # The Status-Line of the Response.
    # 
    # @example
    #     response = Webbed::Response.new([200, {}, ''])
    #     response.status_line # => "HTTP/1.1 200 OK\r\n"
    # 
    # @return [String]
    def status_line
      "#{http_version} #{status_code} #{reason_phrase}\r\n"
    end
    alias_method :start_line, :status_line
    
    include Helpers::RackResponseHelper
    include Helpers::ResponseHeadersHelper
    include Helpers::EntityHeadersHelper
  end
end