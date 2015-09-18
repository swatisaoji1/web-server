require_relative 'request'
require_relative 'response'

# This class will be executed in the context of a thread, and
# should instantiate a Request from the client (socket), perform
# any logging, and issue the Response to the client.
module WebServer
  class Worker
    
    attr_reader :response, :server, :client_socket
    # Takes a reference to the client socket and the logger object
    def initialize(client_socket, server=nil)
      puts "initializing request.. in worker"
      @client_socket = client_socket
      puts client_socket.inspect
      @server = server
      puts server.inspect
      @request = client_socket.gets
    end

    # Processes the request
    def process_request
      @request_o = Request.new(@request)
      @res = Resource.new(@request_o, @server.httpd_conf, @server.mime_types)
      # @res.get_resource
      # create a response object
      @response_o = Response::Factory.create(@res)
      @response = @response_o.body

      
      
    end
    
    
    
    
    
    
    
  end
end
