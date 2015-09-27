require_relative 'response/base'
require 'date'

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
          auth = WebServer::AuthBrowser.new(res, res.conf.access_file_name, res.conf.document_root)
          if auth.protected?
            self.handle_authorized_access(full_path, auth, res)
          else
            self.handle_normal_access(full_path, res)
          end
        else
          Response::NotFound.new(res)
        end  
      end
      
      
      def self.handle_cgi(path, resource)
        puts path
        script_output = IO.popen(path).read # pass param
        responce_obj = Response::OK.new(resource)
        responce_obj.mime_type="text/html"
        responce_obj.body=script_output
        return responce_obj
      end
      
      def self.handle_normal_access(full_path, res)
        if res.script_aliased?
          self.handle_cgi(full_path, res) 
        else
          puts res.request.modified_since
          puts File.mtime(full_path).to_date
          if !res.request.modified_since.nil? && res.request.modified_since <= File.mtime(full_path).to_date
            Response::NotModified.new(res)
          else
            Response::OK.new(res)
          end
        end
      end
      
      def self.handle_authorized_access(full_path, auth, res)
        if auth.authorized?
          self.handle_normal_access(full_path, res)
        else
          Response::Unauthorized.new(res)
        end
      end
      
      
      def self.error(resource, error_object)
        Response::ServerError.new(resource, exception: error_object)
      end
    end
  end
end
