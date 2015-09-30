module WebServer
  module Response
    # Class to handle 401 responses
    class Unauthorized < Base
      attr_accessor :code_no
      def initialize(resource, options={})
        super(resource)
        @body = nil
        @mime_type = "text/html"
        @code_no = 401
      end
      
      def code
        @code ||= WebServer::Response::RESPONSE_CODES[@code_no]
      end
      
      
      def content
        make_body
        header << @body
      end
      
     # create header
      def header
        header_string = ""
        header_string << "HTTP/1.1 #{@code_no} #{code}\r\n"
        header_string << "WWW-Authenticate: Basic realm= \"Team C Server\"\r\n"
        # TODO pick server and date from the common headers
        header_string << "Server: #{get_server_name}\r\n"
        header_string << "Date: #{date_today}\r\n"
        header_string << "Connection: close}"
        
        if @resource.request.http_method != "HEAD"
          header_string << "Content-Length: #{@body.bytesize}\r\n"
          header_string << "Content-Type: #{@mime_type}\r\n"
          header_string << "\r\n" 
        end 
      end
      
      
      # create body
      def make_body
        @body = ""
        @body << "\r\n"
        @body << "<!DOCTYPE html>"
        @body << "<html>"
        @body << "<body>"
        @body << "<h1> #{@code_no}</h1>"
        @body << "<p> Error code : #{code}</p>"
        @body << "<p> Sorry you are not authorized to access this page </p>"
        @body << "</body>"
        @body << "</html>"
      end
    
    end
  end
end
