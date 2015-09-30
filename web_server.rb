require 'socket'
Dir.glob('lib/**/*.rb').each do |file|
  require file
end

module WebServer
  class Server
    
    attr_accessor :httpd_conf, :mime_types
    DEFAULT_PORT = 2468
    ROOT_DIRECTORY = './public_html' # will eventually come from config
    CONFIG_FILE = 'config/httpd.conf'

    def initialize(options={})
      # Set up WebServer's configuration files 
      begin
        @httpd_conf = HttpdConf.new(read_file('config/httpd.conf'))
        @mime_types = MimeTypes.new(read_file('config/mime.types'))
      rescue 
        puts "Error in reading/ creating config or mimes , please check file locations and name"
      end
    end

    def start
      # Begin your 'infinite' loop, reading from the TCPServer, and
      # processing the requests as connections are made
      port = if !get_port.nil? then get_port else DEFAULT_PORT end
      server = TCPServer.new('127.0.0.1', port) 
      print "\nTeam -C server listening at port:#{port}..."
      loop do
        threads = []
        threads << Thread.start(server.accept) do |socket|
          @worker = Worker.new(socket, self)   
          processed = @worker.process_request
          if processed
            response = @worker.response
            socket.print response
          end
          print "\nTeam -C server listening..."
          socket.close 
          end
          threads.each { |thr| thr.join }
        end
      end

    def get_port
      @httpd_conf.port
    end
    
    def read_file(path)
      if File.exists?(path)
        File.open(path, 'r')
      end
    end

  end
end

WebServer::Server.new.start

