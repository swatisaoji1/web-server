require_relative 'request'
require_relative 'response'

# This class will be executed in the context of a thread, and
# should instantiate a Request from the client (socket), perform
# any logging, and issue the Response to the client.
module WebServer
  class Worker
    
    attr_reader :response, :server, :client_socket, :logger
    # Takes a reference to the client socket and the logger object
    def initialize(client_socket, server=nil)
      puts "initializing request.. in worker"
      @client_socket = client_socket
      puts client_socket.inspect
      @server = server
     
      @request = ""
      while next_line_readable?(client_socket)
        @request << client_socket.gets
      end
      puts @request
    end

    # Processes the request
    def process_request
      if @request.length > 0
        @request_o = Request.new(@request)
        puts "request uri from worker #{@request_o.uri}"
        @res = Resource.new(@request_o, @server.httpd_conf, @server.mime_types)
        
        # @res.get_resource
        # create a response object
        @response_o = Response::Factory.create(@res)
        @response = @response_o.content
        
        # create a logger object
        @logger = Logger.new(@server.httpd_conf.log_file)
        @logger.log(@request_o,@response_o)
        @logger.close
        true
      else
        false
      end
    end 
    
    
    # fd be nil if next line cannot be read
    def next_line_readable?(socket)
      readfds, writefds, exceptfds = select([socket], nil, nil, 0.1)
      readfds 
    end
       
  end
end
