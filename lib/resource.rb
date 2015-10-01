module WebServer
  class Resource
    attr_accessor :request, :conf, :mimes , :resolved_path, :final_uri

    def initialize(request, httpd_conf, mimes)
      @request = request 
      @path = request.uri.dup   
      @conf = httpd_conf
      @mimes = mimes
      @resolved_path =""
      @final_uri = nil
      
    end
    
    
    def full_uri
      @final_uri ||= begin
        full_path = File.join(@conf.document_root, @path)
        # TODO modify for delete
        if File.file?(full_path) || @request.http_method == "PUT" || @request.http_method == "DELETE"
          @request.uri
        else
          File.join(@path, @conf.directory_index)
        end
      end
      @final_uri 
    end
    
    def resolve
      full_uri
      if !script_aliased? && !aliased?
        @resolved_path = File.join(@conf.document_root, @final_uri)
      end
      if script_aliased?
        replace_script_aliases
        @resolved_path = @path
      end
      if aliased?
        replace_aliases
        @resolved_path = @path
      end
      return @resolved_path
    end
    

    
    def make_resource
      resolve
      somepath =  @resolved_path
      if File.exists?(@resolved_path) 
        if File.directory?(@resolved_path) && @request.http_method != "PUT"
          @resolved_path = File.join(@resolved_path, @conf.directory_index)
        end
      end
      @resolved_path
    end
    
    
    def replace_script_aliases
      @conf.script_aliases.each do |s_aliases|
        @path.sub!(s_aliases, @conf.script_alias_path(s_aliases))
      end
    end
    
    def replace_aliases
       @conf.aliases.each do |aliases|
         @path.sub!(aliases,@conf.alias_path(aliases)) 
       end
    end
    
    def script_aliased?
      found = false
      @conf.script_aliases.each do |s_aliases|
        found = @request.uri.start_with?(s_aliases)
        if found == true then break end
      end
      return found
    end
    
    def aliased?
      found = false
      @conf.aliases.each do |aliase|
        this_uri_dup = @test_uri
        found= @request.uri.start_with?(aliase)
        if found == true then break end
      end
      return found
    end
    
    
    # TODO check if required 
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
