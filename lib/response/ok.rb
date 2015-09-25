module WebServer
  module Response
    # Class to handle 200 responses
    class OK < Base
      attr_accessor :code_no
      
      def initialize(resource, options={})
        super(resource)
        puts "initializing ok class"
        @file_path = resource.resolved_path
        @content = nil
        @code_no = 200
      end
     
      
      def mime_type
        extension = File.extname(@file_path).delete('.')
        return @resource.mimes.for_extension(extension)
      end
      
      def code
        @code ||= WebServer::Response::RESPONSE_CODES[@code_no]
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
        # TODO pick server and date from the common headers
        header_string << "Server: Team C Swati and Harini\r\n"
        header_string << "Date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %Z')}"
        puts @resource.inspect
        puts @resource.request.http_method.inspect
        
        if @resource.request.http_method != "HEAD"
          puts  body.bytesize
          header_string << "Content-Length: #{body.bytesize}\r\n"
          puts mime_type
          header_string << "Content-Type: #{mime_type}\r\n"
          header_string << "\r\n" 
        end 
      end
      
      # create body
      def body
        if File.exists?(@file_path)
          File.read(@file_path)
        else
          ""
        end
      end
      

      
      
    end
  end
end
