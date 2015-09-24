module WebServer
  module Response
    # Provides the base functionality for all HTTP Responses 
    # (This allows us to inherit basic functionality in derived responses
    # to handle response code specific behavior)
    class Base
      attr_reader :version, :code, :body

      def initialize(resource, options={})
        @resource = resource
        @version = resource.request.version
        @body = create_body
      end

      def to_s
        
      end

      def message
      end

      def content_length
        length = @body.length
        puts length
        return @body.length
      end
      
      def res_exists?(r_name)
        File.exist?(r_name) 
      end
      
      def is_directory?(r_name)
        File.directory?(r_name)
      end
      
      def create_body
        body = ''
        res_file = @resource.get_resource
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
