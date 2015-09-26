require_relative 'configuration'

# Parses, stores, and exposes the values from the httpd.conf file
module WebServer
  class HttpdConf < Configuration
    def initialize(file_content)
	    #read config files here
	    # TODO refactor the code
      @config_map = Hash.new
      file_content.each_line do |line|
        @inner_hash = Hash.new
        line = line.gsub(/#(.*)/, '')
        words = line.scan(/\S+/)
        if(!words.empty?)
          words.map { |word|   word.gsub!(/\A"|"\Z/, '') }
          @count = words.length
          w1 = words.shift
          w2 = words.shift
          
          
          if (@count>2)
           @inner_hash[w2]=words
           res=words
          else
           @inner_hash[w1]=w2
           res=w2
          end
          
          #puts @config2_map.to_s
          if(@config_map[w1].nil?)
           @config_map[w1]=@inner_hash
          else
           @config_map[w1].merge!(@inner_hash)
          end
        end
      end
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
    	return ""
    end

    # Returns the directory index file
    def directory_index
    	if @config_map.has_key?("DirectoryIndex")
    	 @config_map["DirectoryIndex"].each do |k,v|
         return "#{v}"
        end
    	end
    	return "index.html"
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
    	a=[]
      	@config_map["ScriptAlias"].each do |k,v|
      	 a << k
      	end
    	return a
    end

    # Returns the aliased path for a given ScriptAlias directory
    def script_alias_path(path)
    	@config_map["ScriptAlias"].each do |k,v|
    		if path=="#{k}"
    		 return v[0]
    		end
    	end
    	return nil
    end

  # Returns an array of Alias directories
  def aliases
    array_aliases =[]
    	if @config_map.has_key?("Alias")
    	 @config_map["Alias"].each do |k,v|
      	 array_aliases << k
  	   end
  	   return array_aliases
	   end
   end

    # Returns the aliased path for a given Alias directory
    def alias_path(path)
	    @config_map["Alias"].each do |k,v|
        if path=="#{k}"
         return v[0]
        end
      end
      return nil
    end
    
    
 end
end
