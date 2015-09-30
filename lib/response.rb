require_relative 'response/base'
require 'date'

module WebServer
  module Response
    attr_accessor :code_no
    DEFAULT_HTTP_VERSION = 'HTTP/1.1'

    RESPONSE_CODES = {
      200 => 'OK',
      201 => 'Successfully Created',
      204 => 'Successfully Deleted',
      304 => 'Not Modified',
      400 => 'Bad Request',
      401 => 'Unauthorized',
      403 => 'Forbidden',
      404 => 'Not Found',
      500 => 'Internal Server Error'
    }.freeze

    DEFAULT_HEADERS =
      {
        'Date' => Time.now.strftime('%a, %e %b %Y %H:%M:%S %Z'),
        'Server' => 'Team -C Server: Harini and Swati'
      }

    module Factory
      def self.create(resource)
        resource.make_resource
        if !resource.request.supported_verbs.include?(resource.request.http_method) 
          return Response::BadRequest.new(resource)
        elsif resource.request.http_method == "PUT"
          self.handle_put_request(resource)
        elsif resource.request.http_method == "DELETE"
          self.handle_delete_request(resource) 
        else
          self.handle_valid_request(resource)
        end 
      end


      def self.handle_valid_request(res)
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

      def code_no
        @code_no
      end
      
      def code
        @code ||= WebServer::Response::RESPONSE_CODES[@code_no]
      end  

      def self.handle_cgi(path, resource)
        # create [ENV, path, arg1, arg2, arg3 ...]
        arguments = [ENV, path].concat make_param_array(resource)
        
        #passing arguments with path to popen
        script_output = IO.popen(arguments).read # pass param
        responce_obj = Response::OK.new(resource)
        responce_obj.mime_type="text/html"
        responce_obj.body=script_output
        return responce_obj
      end
      
      def self.make_param_array(resource)
        param_hash = resource.request.params
        param_array = param_hash.values
        param_array
      end
      
      def self.handle_normal_access(full_path, res)
        if res.script_aliased?
          self.handle_cgi(full_path, res) 
        else
=begin
          puts res.request.modified_since
          puts File.mtime(full_path).to_date
          if !res.request.modified_since.nil? && res.request.modified_since == File.mtime(full_path).to_date
            Response::NotModified.new(res)
          else
=end
            Response::OK.new(res)
#          end
        end
      end
      
      def self.handle_authorized_access(full_path, auth, res)
        if !auth.has_auth_head? 
          Response::Unauthorized.new(res)
        elsif !auth.authorized?
          Response::Forbidden.new(res)
        else
          self.handle_normal_access(full_path, res)
        end
      end
      
      def self.handle_put_request(resource)
        #TODO error catch if key missing
        full_path = resource.resolved_path
        content_type = resource.request.headers['CONTENT_TYPE']
        content_length = resource.request.headers['CONTENT_LENGTH'].to_i
        body = resource.request.body
        if File.exists?(full_path)
          written_length = File.open(full_path,"w") {
            |file| file.write(body)
          }
        else
          written_length = File.open(full_path,"w") {
            |file| file.write(body)
          }
        end
        success_response = Response::SuccessfullyCreated.new(resource)
        success_response.written_length = written_length
        success_response.content_type = content_type
        success_response
      end
      
      def self.handle_delete_request(resource)
        full_path = resource.resolved_path
        content_type = resource.request.headers['CONTENT_TYPE']
        if File.exists?(full_path)
          File.delete(full_path)
        end
        success_response = Response::SuccessfullyDeleted.new(resource)
        success_response.content_type = content_type
        success_response
      end

      def self.error(resource, error_object)
        Response::ServerError.new(resource, exception: error_object)
      end
    end
  end
end
