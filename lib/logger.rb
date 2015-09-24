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
  	 if File.exists?(@log_file_path)
  	  File.open(@log_file_path,"a")
  	 else
	  expanded = File.expand_path(__FILE__)
	  full_path = expanded + "log.txt"
  	  File.new(full_path,"a")
  	 end
  	end
   end
    # Log a message using the information from Request and 
    # Response objects
    def log(request, response)
    	log_file.write("Hello!\n")
    	log_file.write("Hi Hi\n")
    end

    # Allow the consumer of this class to flush and close the 
    # log file
    def close
	log_file.close
    end
  end
end
