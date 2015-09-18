module WebServer
  class Resource
    attr_reader :request, :conf, :mimes

    def initialize(request, httpd_conf, mimes)
      @request = request 
      @path = request.uri   
      @conf = httpd_conf
      @mimes = mimes
    end
    
    def get_resource
       replace_script_aliases
       replace_aliases@path
       return @path
    end
    
    def make_resource
      
    end
    def replace_script_aliases
      @conf.script_aliases.each do |s_aliases|
        @path.gsub!(s_aliases, @conf.script_alias_path(s_aliases)) 
      end
    end
    
    def replace_aliases
       @conf.aliases.each do |aliases|
         @path.gsub!(aliases,@conf.alias_path(aliases)) 
       end
    end
    
    def is_script_alias?
      @conf.script_aliases.each do |s_aliases|
        @request.uri.include?(s_aliases)
      end
    end
    
    def is_alias?
      @conf.aliases.each do |aliase|
        @request.uri.include?(aliase)
      end  
    end
    
    def get_mime_type
      if !File.directory?(@path) then
        file_extension = File.extname(@path)
        @mimes.for_extension(file_extension)
      else
        "text/plain"
      end
    end
    
    
    
  end
end
