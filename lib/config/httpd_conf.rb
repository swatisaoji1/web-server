require_relative 'configuration'

# Parses, stores, and exposes the values from the httpd.conf file
module WebServer
  class HttpdConf < Configuration
    def initialize(file_content)
      @config_map = Hash.new
      file_content.each_line do |line|
        @inner_hash = Hash.new
        words = line.gsub(/#(.*)/, '').scan(/\S+/)
        if(!words.empty?)
          words.map { |word|   word.gsub!(/\A"|"\Z/, '') }
          @count = words.length
          first_word = words.shift
          second_Word = words.shift
          
          # create a nested hash to handle multiple entries eg Alias
          if (@count>2)
           @inner_hash[second_Word]=words
           res=words
          else
           @inner_hash[first_word]=second_Word
           res=second_Word
          end
          
          #puts @config2_map.to_s
          if(@config_map[first_word].nil?)
           @config_map[first_word]=@inner_hash
          else
           @config_map[first_word].merge!(@inner_hash)
          end
          
        end
      end
    end

    # Returns the value of the ServerRoot
    def server_root 
      if @config_map.has_key?("ServerRoot")
    	  @config_map["ServerRoot"].each { |k,v| return "#{v}"}
     	end
    end

    # Returns the value of the DocumentRoot
    def document_root
    	if @config_map.has_key?("DocumentRoot")
    	 @config_map["DocumentRoot"].each {|k,v| return "#{v}"} 
    	end
    	return ""
    end

    # Returns the directory index file
    def directory_index
    	if @config_map.has_key?("DirectoryIndex")
    	 @config_map["DirectoryIndex"].each { |k,v| return "#{v}"}
    	end
    	# default directory index if not provided in config
    	return "index.html"
    end

    # Returns the *integer* value of Listen
    def port
    	if @config_map.has_key?("Listen")
    	 @config_map["Listen"].each { |k,v| return "#{v}".to_i}
    	end
    end

    # Returns the value of LogFile
    def log_file
    	if @config_map.has_key?("LogFile")
    	 @config_map["LogFile"].each {|k,v| return "#{v}" }
    	end
    end


    # Returns the name of the AccessFile 
    def access_file_name
  	   if @config_map.has_key?("AccessFile")
         @config_map["AccessFile"].each { |k,v| return "#{v}" }
      end
      return ".htaccess"
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
