module WebServer
  module Response
    # Class to handle 400 responses
    class BadRequest < Base
      attr_accessor :code_no
      def initialize(resource, options={})
        super(resource)
        puts "initializing BadRequest class"
        @file_path = resource.resolved_path
        @content = nil
        @code_no = 400
        @body = nil
        @header = nil
      end
      
      
      def code
        @code ||= WebServer::Response::RESPONSE_CODES[@code_no]
      end   
      
      #TODO code repeat cleaning
      def content
        make_body
        header << @body
      end
      
      # create header
      #TODO code repetation move to base class 

      def header
        header_string = ""
        header_string << "HTTP/1.1 #{@code_no} #{code}\r\n"
        # TODO pick server and date from the common headers
        header_string << "Server: Team C Swati and Harini\r\n"
        header_string << "Date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %Z')}" 
        header_string << "Content-Length: #{@body.bytesize}\r\n"
        header_string << "\r\n" 
      end
      
      
       def body 
        @body ||= begin 
          body = ""
          body << "<!DOCTYPE html>"
          body << "<html>"
          body << "<body>"
          body << "<h1> #{@code_no}</h1>"
          body << "<p> Error code : #{code}</p>"
          body << "<p> Sorry Bad Request</p>"
          body << "</body>"
          body << "</html>"
          body
        end
      end

    end
  end
end

