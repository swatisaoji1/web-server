module WebServer
  module Response
    # Class to handle 200 responses
    class OK < Base
      attr_accessor :code_no , :mime_type, :body
      
      def initialize(resource, options={})
        super(resource)
        puts "initializing ok class"
        @file_path = resource.resolved_path
        @body = nil
        @mime_type = nil
        @code_no = 200
      end
     
      
      def mime_type
        @mime_type ||= @resource.mimes.for_extension(File.extname(@file_path).delete('.'))
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
        # TODO pick server and date from the common headers
        header_string << "Server: Team C Swati and Harini\r\n"
        header_string << "Date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %Z')}"
        header_string << "Connection: close}"
        
        if @resource.request.http_method != "HEAD"
          header_string << "Content-Length: #{@body.bytesize}\r\n"
          header_string << "Content-Type: #{@mime_type}\r\n"
          header_string << "\r\n" 
        end 
      end
      
      # create body
      def make_body
        @body||=begin
          if File.exists?(@file_path)
            File.read(@file_path)
          end
        end
      end
      

      
      
    end
  end
end
