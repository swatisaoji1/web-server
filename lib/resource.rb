module WebServer
  class Resource
    attr_reader :request, :conf, :mimes

    def initialize(request, httpd_conf, mimes)
      @request = request
      @conf = httpd_conf
      @mimes = mimes
    end
    
    def get_resource
      #lets return a dummy resource
      return "/home/swati/clones from git/Server_Team_C/Server_C/public_html/test.html"
    end
    
    
  end
end
