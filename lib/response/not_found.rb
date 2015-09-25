module WebServer
  module Response
    # Class to handle 404 errors
    class NotFound < Base
      def initialize(resource, options={})
        puts "file not found"
      end
      
      
    end
  end
end
