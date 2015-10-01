module WebServer
  module Response
    # Class to handle 200 responses
    class OK < Base
      attr_accessor :code_no , :mime_type, :body
      
      def initialize(resource, options={})
        super(resource)
        @body = nil
        @mime_type = "text/html"
        @code_no = 200
      end
     
      
      def mime_type
        @mime_type = @resource.mimes.for_extension(File.extname(@file_path).delete('.'))
      end
      
      def code
        @code ||= WebServer::Response::RESPONSE_CODES[@code_no]
      end
      
      
      def content
        make_body
        header << @body
      end
      
       def expiry
         (Time.now+10*60).strftime('%a, %e %b %Y %H:%M:%S %Z')
       end
       
       def age
         File.atime(@file_path).strftime('%a, %e %b %Y %H:%M:%S %Z')
       end
      
      # create header
      def header
        header_string = ""
        header_string << "HTTP/1.1 #{@code_no} #{code}\r\n"
        # TODO pick server and date from the common headers
        header_string << "Server: #{get_server_name}\r\n"
        header_string << "Date: #{date_today}\r\n"
        header_string << "Last-Modified: #{last_modified} \r\n"
        header_string << "Expires: #{expiry}\r\n"
        
        # Connection Close
        
        
        if @resource.request.http_method != "HEAD"
          header_string << "Content-Length: #{get_body_size}\r\n"
          header_string << "Content-Type: #{@mime_type}\r\n"
          header_string << "\r\n" 
        end 
        header_string
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
