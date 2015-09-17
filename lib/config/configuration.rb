# This class should be used to encapuslate the functionality 
# necessary to open and parse configuration files. See
# HttpdConf and MimeTypes, both derived from this parent class.
module WebServer
  class Configuration
	attr_accessor :res

    def initialize(file_content)
      #read config files here
      @config_map = Hash.new
      file_content.each_line do |line|
	@config2_map = Hash.new
        line = line.gsub(/#(.*)/, '')
        words = line.scan(/\S+/)
        if(!words.empty?)
          words.map { |word|   word.gsub!(/\A"|"\Z/, '') }
          @count = words.length
	  w1 = words.shift
 	  w2 = words.shift
	  if (@count>2)
	   @config2_map[w2]=words
	   res=words
	  else
	   @config2_map[w1]=w2
	   res=w2
	  end
	  #puts @config2_map.to_s
	  if(@config_map[w1].nil?)
	   @config_map[w1]=@config2_map
	  else
	   @config_map[w1].merge!(@config2_map)
	  end
        end
	puts res.to_s	
      end
      #puts res.to_s
    end

  end

end

