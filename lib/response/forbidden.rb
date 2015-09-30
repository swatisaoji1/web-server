module WebServer
  module Response
    # Class to handle 403 responses
    class Forbidden < Base
      attr_accessor :code_no
      def initialize(resource, options={})
      	super(resource)
      	@file_path = resource.resolved_path
      	@content = nil
      	@code_no = 403
      end

      def code
        @code ||= WebServer::Response::RESPONSE_CODES[@code_no]
      end	

      def mime_type
        extension = File.extname(@file_path).delete('.')
        return @resource.mimes.for_extension(extension)
      end

      def content
        @content ||= begin
          body
          header << @body
        end
      end
      
      
      # create header
      def header
        header_string = ""
        header_string << "HTTP/1.1 #{@code_no} #{code}\r\n"
        header_string << "Server: #{get_server_name}\r\n"
        header_string << "Date: #{date_today}\r\n"
        
        if @resource.request.http_method != "HEAD"
          puts  body.bytesize
          header_string << "Content-Length: #{@body.bytesize}\r\n"
          puts mime_type
          header_string << "Content-Type: #{mime_type}\r\n"
          header_string << "\r\n" 
        end 
      end

      def body   
        @body = ""
        @body << "<!DOCTYPE html>"
        @body << "<html>"
        @body << "<body>"
        @body << "<p> Error code : #{code}</p>"
        @body << "<p> Sorry you are not authorized to access this page </p>"
        @body << "</html>"
      end

    end
  end
end
