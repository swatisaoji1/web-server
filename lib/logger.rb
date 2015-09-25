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
  	  puts "log file is : "
  	  puts @log_file_path
  	 if File.exists?(@log_file_path)
  	  File.open(@log_file_path,"a")
  	 else
  	  File.new("log.txt","w")
  	 end
  	end
   end
    # Log a message using the information from Request and 
    # Response objects
    def log(request, response)
      puts "request body is : "
      puts request.http_method
      h = log_file
      text_to_write = ""
      text_to_write << "#{request.http_method}\n"
      
      resp_code = response.code
      puts "response code is #{resp_code}"
      
      text_to_write << "#{response.code}\n"
      text_to_write << "#{response.code_no}\n"
      # TODO error catching for IO error
      h.write(text_to_write)
    end

    # Allow the consumer of this class to flush and close the 
    # log file
    def close
	log_file.close
    end
  end
end
