module WebServer
  module Response
    # Class to handle 500 errors
    class ServerError 
      attr_accessor :code_no
      def initialize(resource=nil, options={})
      	puts "initializing ServerError class"
      	@code_no = 500
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
          header << body
        end
      end
      
      
      # create header
      def header
        header_string = ""
        header_string << "HTTP/1.1 #{@code_no} #{code}\r\n"
        header_string << "Server: #{WebServer::Response::DEFAULT_HEADERS['Server']}\r\n"
        header_string << "Date: #{WebServer::Response::DEFAULT_HEADERS['Date']}\r\n"
        header_string << "Content-Length: #{body.bytesize}\r\n"
        header_string << "\r\n" 
        
        
      end

      def body   
        body = ""
        body << "<!DOCTYPE html>"
        body << "<html>"
        body << "<body>"
        body << "<h1> #{@code_no}</h1>"
        body << "<p> Error code : #{code}</p>"
        body << "<p> Ops Server Fault  :( </p>"
        body << "</body>"
        body << "</html>"
        return body
      end

    end
  end
end
