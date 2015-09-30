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
      @request = nil
      
      # TODO error catching
      read_socket(client_socket)
    end

    # Processes the request
    def process_request
      if @request.length > 0
        @request_o = Request.new(@request)
        puts "request uri from worker #{@request_o.uri}"
        @res = Resource.new(@request_o, @server.httpd_conf, @server.mime_types)
        # create a response object
        @response_o = Response::Factory.create(@res)
        @response = @response_o.content
        puts @response
        # create a logger object
        
        @logger = Logger.new(@server.httpd_conf.log_file)
        @logger.log(@request_o,@response_o) 
        @logger.close

        true
      else
        false
      end
    end 
    
    
    def read_socket(client_socket)
      rescue SocketError
        raise SocketError
      else
        request =""
        body = ""
        header_done = false
        length = 0
        while next_line_readable?(client_socket)
          if !header_done
            line = client_socket.gets 
            request << line
            if line.include? "Content-Length" then length = line.split(':')[1].to_i end
            if line.strip.empty?
              header_done = true 
            end
          else
            while body.bytesize < length
              body << client_socket.getc
            end
            body << "\r\n"
          end
        end
        request << body
        @request = request
        puts @request
    end
    
    # fd be nil if next line cannot be read
    def next_line_readable?(socket)
      readfds, writefds, exceptfds = select([socket], nil, nil, 0.1)
      readfds 
    end
       
  end
end
