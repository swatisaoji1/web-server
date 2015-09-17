require 'socket'
Dir.glob('lib/**/*.rb').each do |file|
  require file
end

module WebServer
  class Server
    DEFAULT_PORT = 2469
    ROOT_DIRECTORY = './public_html' # will eventually come from config
    CONFIG_FILE = 'config/httpd.conf'

    def initialize(options={})
      # Set up WebServer's configuration files and logger here
      # Do any preparation necessary to allow threading multiple requests
      
      
      #TODO need to handle missing config / mime file to return server fault
      @file = File.open('config/httpd.conf', 'r') 
      @httpd_conf = HttpdConf.new(@file)
      
      @file = File.open('config/mime.types', 'r') 
      @mime_types = MimeTypes.new(@file)
      
      @no_of_threads = 0
    end

    def start
      # Begin your 'infinite' loop, reading from the TCPServer, and
      # processing the requests as connections are made
      server = TCPServer.new('127.0.0.1', DEFAULT_PORT) 
      print "listening..."
      loop do
        Thread.start(server.accept) do |client|
          request = client.gets
          @worker = Worker.new(request)         
          # initialize request object
          @request_o = Request.new(request)
          #conflict
          response = "Hello World\n"
          client.print "HTTP/1.1 200 OK\r\n" +
               "Content-Type: text/plain\r\n" +
               "Content-Length: #{response.bytesize}\r\n" +
               "Connection: close\r\n"
          client.print "\r\n"
          client.print response
          client.close
        end
      end
      
    end
  

    private
  
  #here there is comment
  end
end

WebServer::Server.new.start

