require 'socket'
require 'fileutils'
module WebServer
  class Logger

    # Takes the absolute path to the log file, and any options
    # you may want to specify.  I include the option :echo to 
    # allow me to decide if I want my server to print out log
    # messages as they get generated
    
    
    def initialize(log_file_path, options={})
    	@option = options
    	@log_file_path = log_file_path
    	@log_file = nil
    end

    def log_file
      @log_file ||= begin
      dir = File.dirname(@log_file_path)
     
     # if log directory exists
      if File.directory?(dir)
        if File.exists?(@log_file_path)
          File.open(@log_file_path,"a")
        else
          File.new(@log_file_path,"a")
        end
     
      # if log directory does not exists create one
      else
        FileUtils.mkdir_p(dir)
        if File.exists?(@log_file_path) 
          File.open(@log_file_path,"a")
        else
          File.new(@log_file_path,"a")
        end
      end
  	end
   end
   
   
    # Log a message using the information from Request and Response objects
    def log(request, response)
	    date = Time.now.strftime('%a, %e %b %Y %H:%M:%S %Z')
      ip = IPSocket.getaddress(Socket.gethostname)
       #TODO check for remote logger
      log_file.write(ip+" ") unless ip.nil?
      log_file.write(date+" ") unless date.nil?
      log_file.write("#{request.class} ") unless request.class.nil?
      log_file.write("#{request.http_method} ") unless request.http_method.nil?
      log_file.write("#{request.uri} ") unless request.uri.nil?
      log_file.write("#{request.version} ") unless request.version.nil?
      log_file.write("#{response.code_no} ") unless response.code_no.nil?
      log_file.write("#{response.get_body_size}\n") unless response.get_body_size.nil? 
    end

    # Allow the consumer of this class to flush and close the log file
    def close
	    log_file.close
    end
    
  end
end
