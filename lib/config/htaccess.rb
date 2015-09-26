module WebServer
  class Htaccess
     
     attr_reader :file_content_arr
    
    def initialize(htaccess_file_content)
      @file_content_arr = Hash.new
      htaccess_file_content.each_line do |line|
        words = line.gsub(/#(.*)/, '').scan(/\S+/)
        if !words.empty? then @file_content_arr[words.shift] = words.shift.gsub!(/\A"|"\Z/, '') end
      end
      
    end
    
    def auth_user_file
      if @file_content_arr.has_key?('AuthUserFile')
        @file_content_arr['AuthUserFile']
      end
    end
    
    def auth_type
      if @file_content_arr.has_key?('AuthType')
        @file_content_arr['AuthType']
      end
    end
    
    def auth_name
      if @file_content_arr.has_key?('AuthName')
        @file_content_arr['AuthName']
      end
    end
    
    def require
      if @file_content_arr.has_key?('Require')
        @file_content_arr['Require']
      end
    end
    
    
    
    
      

  end
end