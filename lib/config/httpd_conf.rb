require_relative 'configuration'

# Parses, stores, and exposes the values from the httpd.conf file
module WebServer
  class HttpdConf < Configuration
    def initialize(httpd_file_content)
	super(httpd_file_content)
    end

    # Returns the value of the ServerRoot
    def server_root 
	if @config_map.has_key?("ServerRoot")
	 @config_map["ServerRoot"].each do |k,v|
	  return "#{v}"
  	 end
 	end
    end

    # Returns the value of the DocumentRoot
    def document_root
	if @config_map.has_key?("DocumentRoot")
	 @config_map["DocumentRoot"].each do |k,v|
          return "#{v}"
         end
	end
    end

    # Returns the directory index file
    def directory_index
	if @config_map.has_key?("DirectoryIndex")
	 @config_map["DirectoryIndex"].each do |k,v|
          return "#{v}"
         end
	end
    end

    # Returns the *integer* value of Listen
    def port
	if @config_map.has_key?("Listen")
	 @config_map["Listen"].each do |k,v|
          return "#{v}".to_i
         end
	end
    end

    # Returns the value of LogFile
    def log_file
	if @config_map.has_key?("LogFile")
	 @config_map["LogFile"].each do |k,v|
          return "#{v}"
         end
	end
    end

    # Returns the name of the AccessFile 
    def access_file_name
	if @config_map.has_key?("AccessFile")
         @config_map["AccessFile"].each do |k,v|
          return "#{v}"
         end
        end
    end

    # Returns an array of ScriptAlias directories
    def script_aliases
	@config_map["ScriptAlias"].each do |k,v|
		return "#{v}"
	end
    end

    # Returns the aliased path for a given ScriptAlias directory
    def script_alias_path(path)
	
    end

    # Returns an array of Alias directories
    def aliases
      	if @config_map.has_key?("Alias")
      	 @config_map["Alias"].each do |k,v|
	  puts "#{v}"
  	 end
	end
   end

    # Returns the aliased path for a given Alias directory
    def alias_path(path)
		
    end
 end
end
