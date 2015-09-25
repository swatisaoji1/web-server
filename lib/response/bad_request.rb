module WebServer
  module Response
    # Class to handle 400 responses
    class BadRequest < Base
      def initialize(resource, options={})
        puts "initialing bad responce" ;
      end
    end
  end
end
