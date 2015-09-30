
module WebServer
  module Response
    # Provides the base functionality for all HTTP Responses 
    # (This allows us to inherit basic functionality in derived responses
    # to handle response code specific behavior)
    class Base
      attr_reader :version, :code, :body, :code_no

      def initialize(resource, options={})
        @resource = resource
        @version = resource.request.version
        @file_path = resource.resolved_path
        @body = nil
        @code_no = 200
      end

      def get_server_name
        WebServer::Response::DEFAULT_HEADERS['Server']
      end
        
        
      def date_today
        WebServer::Response::DEFAULT_HEADERS['Date']
      end

      def last_modified
        File.mtime(@file_path).strftime('%a, %e %b %Y %H:%M:%S %Z')
      end
      
      def get_body_size
        if !@body.nil? 
           @body.length 
        else
          0
        end 
      end
    

      def content_length
        @body.length
      end
      
      def res_exists?(r_name)
        File.exist?(r_name) 
      end
      
      def is_directory?(r_name)
        File.directory?(r_name)
      end
      
      def create_body
        body = ''
        res_file = @resource.resolved_path
        puts res_file
        f = File.open(res_file, "r")
        f.each_line do |line|
          body << line
        end
        f.close
        return body         
      end
       
    end
  end
end
