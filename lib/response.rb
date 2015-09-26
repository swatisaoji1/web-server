require_relative 'response/base'

module WebServer
  module Response
    DEFAULT_HTTP_VERSION = 'HTTP/1.1'

    RESPONSE_CODES = {
      200 => 'OK',
      201 => 'Successfully Created',
      304 => 'Not Modified',
      400 => 'Bad Request',
      401 => 'Unauthorized',
      403 => 'Forbidden',
      404 => 'Not Found',
      500 => 'Internal Server Error'
    }.freeze

    def self.default_headers
      {
        'Date' => Time.now.strftime('%a, %e %b %Y %H:%M:%S %Z'),
        'Server' => 'John Roberts CSC 667'
      }
    end

    module Factory
      def self.create(resource)
        resource.make_resource
        
        if !resource.request.supported_verbs.include?(resource.request.http_method) 
          puts 'handling unsupported request verb'
          return Response::BadRequest.new(resource)
        else
          self.handle_valid_request(resource)
        end 
      end


      def self.handle_valid_request(res)
        puts 'handling valid request verb'
        full_path = res.resolved_path
        if File.exists?(full_path)
          if res.script_aliased?
            self.handle_cgi(full_path, res) 
          else
            Response::OK.new(res)
          end
        else
          Response::NotFound.new(res)
        end  
      end
      
      
      def self.handle_cgi(path, resource)
        puts path
        script_output = IO.popen(path).read
        responce_obj = Response::OK.new(resource)
        responce_obj.mime_type="text/html"
        responce_obj.body=script_output
        return responce_obj
      end
      

      def self.error(resource, error_object)
        Response::ServerError.new(resource, exception: error_object)
      end
    end
  end
end
