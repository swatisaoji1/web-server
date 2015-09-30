module WebServer
  module Response
    # Class to handle 201 responses
    
    class SuccessfullyCreated < Base
      
      attr_accessor :written_length , :content_type
      
      def initialize(resource, options={})
        super(resource)
        @written_length = 0
        @content_type = "text/plain"
        @code_no = 201
      end
      
      #TODO code repeat move to base
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
        header_string << "Content-Type: #{@content_type}\r\n"
        header_string << "Location: #{@file_path}\r\n"
        header_string << "\r\n" 
      end
      
      
    end
  end
end
