module WebServer
  module Response
    # Class to handle 201 responses
    
    class SuccessfullyDeleted < Base
      
      attr_accessor :written_length , :content_type
      
      def initialize(resource, options={})
        super(resource)
        @written_length = 0
        @content_type = nil
        @code_no = 204
      end
      
      #TODO code repeat move to base
      def code
        @code ||= WebServer::Response::RESPONSE_CODES[@code_no]
      end
      
      def content
        header 
      end
      
      # create header
      def header
        header_string = ""
        header_string << "HTTP/1.1 #{@code_no} #{code}\r\n"
        # TODO pick server and date from the common headers
        header_string << "Server: Team C Swati and Harini\r\n"
        header_string << "Date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %Z')}\r\n"
        header_string << "Content-Length: #{@written_length}\r\n"
        header_string << "Content-Type: #{@content_type}\r\n"
        header_string << "\r\n" 
      end
      
      
    end
  end
end
