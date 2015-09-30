module WebServer
  module Response
    # Class to handle 304 responses
    class NotModified < Base
      attr_accessor :code_no
      def initialize(resource, options={})
        super(resource)
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
        header_string << "Server: #{get_server_name}\r\n"
        header_string << "Date: #{date_today}\r\n"
        header_string << "Expires: #{(Time.now+10*60).strftime('%a, %e %b %Y %H:%M:%S %Z')}\r\n"
        puts header_string
      end
    end
  end
end
