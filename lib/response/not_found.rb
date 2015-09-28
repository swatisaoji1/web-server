module WebServer
  module Response
    # Class to handle 404 errors
    
    class NotFound < Base
     def initialize(resource, options={})
        super(resource)
        puts "initializing page not found class"
        @file_path = resource.resolved_path
        @content = nil
        @code_no = 404
        @body = nil
        @header = nil
      end
      
      
      def code
        @code ||= WebServer::Response::RESPONSE_CODES[@code_no]
      end   
      
      def content
        make_body
        puts @body
        header << @body
      end
      
      # create header
      def header
        header_string = ""
        header_string << "HTTP/1.1 #{@code_no} #{code}\r\n"
        # TODO pick server and date from the common headers
        header_string << "Server: Team C Swati and Harini\r\n"
        header_string << "Date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %Z')}" 
        header_string << "Content-Length: #{@body.bytesize}\r\n"
        header_string << "\r\n" 
        header_string
      end
      
      
       def make_body 
        @body ||= begin 
          body = ""
          body << "<!DOCTYPE html>"
          body << "<html>"
          body << "<body>"
          body << "<h1> #{@code_no}</h1>"
          body << "<p> Error code : #{code}</p>"
          body << "<p> Sorry the page you are looking for is not available :( </p>"
          body << "</body>"
          body << "</html>"
        end
      end
      
      
    end
  end
end
