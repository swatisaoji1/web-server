module WebServer
  module Response
    # Class to handle 304 responses
    class NotModified < Base
      def initialize(resource, options={})
        @code_no = 304
      end
      
      
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
        header_string << "Connection: close\r\n"
        puts header_string
      end
      
      
    end
  end
end
