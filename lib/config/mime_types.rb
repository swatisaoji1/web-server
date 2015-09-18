require_relative 'configuration'

# Parses, stores and exposes the values from the mime.types file
module WebServer
  class MimeTypes < Configuration
    def initialize(file_content)
	@config_map = Hash.new
        file_content.each_line do |line|
    
        line = line.gsub(/#(.*)/, '')
        words = line.scan(/\S+/)
        if(!words.empty?)
          words.map { |word|   word.gsub!(/\A"|"\Z/, '') }
          @count = words.length
      	  w1 = words.shift
      	  if(@count>1)
       	   words.each do |w|
            @config_map[w]=w1
           end
          end
        end
        end
    end
    
    # Returns the mime type for the specified extension
    def for_extension(extension)
  	if (@config_map.has_key?(extension))
  	 return @config_map[extension]
  	else
  	  return "text/plain"
  	 end
      end
    end
  end
