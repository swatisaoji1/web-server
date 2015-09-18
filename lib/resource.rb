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
      #lets return a dummy resource
       puts "path was.."
       puts @path
       replace_script_aliases
       replace_aliases
       puts "path is now.."
       puts @path
      return "/home/swati/clones from git/Server_Team_C/Server_C/public_html/test.html"
    end
    
    def make_resource
      
    end
    def replace_script_aliases
      @conf.script_aliases.each do |s_aliases|
        puts "replacing Script Aliases...."
        puts "replacing.."
        puts s_aliases
        puts "with.."
        puts @conf.script_alias_path(s_aliases)
        @path.gsub!(s_aliases, @conf.script_alias_path(s_aliases))
        
      end
    end
    
    def replace_aliases
       puts "replacing Aliases...."
       @conf.aliases.each do |aliases|
         puts "replacing.."
         puts aliases
         puts "with.."
         puts @conf.alias_path(aliases)
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
        p aliase
        output = @request.uri.include?(aliase)
        p output
        return output
        
      end  
    end
    
    
    
    
  end
end
