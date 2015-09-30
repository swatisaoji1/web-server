# The Request class encapsulates the parsing of an HTTP Request
module WebServer
  class Request
    attr_accessor :http_method, :uri, :version, :headers, :body, :params, :supported_verbs, :if_modified_since
    
    @@request_no = 0
    # Request creation receives a reference to the socket over which
    # the client has connected
    def initialize(socket)
      # Perform any setup, then parse the request
      @@request_no += 1
      @headers = Hash.new
      @supported_verbs = ["GET", "HEAD", "POST", "PUT", "DELETE"]
      @current_index = 0
      @if_modified_since = nil
      @request_content = socket
      @length_con = 0
      dump_request
      make_request_array
      if @length_con > 0
        parse
      end 
      
    end



    # Parse the request from the socket - Note that this method takes no
    # parameters
    def parse
      parse_request_line
      while @current_index < @length_con && !blank_line? do
        header = @request_content_array[@current_index].strip
        @current_index += 1
        while space_in_beginning? && !blank_line? do
          header += ' '
          header += @request_content_array[@current_index].strip
          @current_index += 1
        end  
        parse_header(header)
      end
      parse_body
    end


    # The following lines provide a suggestion for implementation - feel free
    # to erase and create your own...
    
    def space_in_beginning?
      !!(@request_content_array[@current_index] =~ /^\s/)
    end
    
    def blank_line?
        @request_content_array[@current_index].strip == ""  
    end
    
    
    def make_request_array
      @request_content_array = Array.new
      @request_content.each_line do |line|
        @request_content_array.push(line)
      end
      @length_con = @request_content_array.length
      puts "request array length #{@length_con}"
    end

  
    def parse_request_line
       @http_method, url, @version = @request_content_array[0].split
       split_url = url.partition("?")
       @uri = split_url[0]
       if @http_method == 'GET' && !split_url[2].nil?
         parse_params(split_url[2])
       end
       @current_index = @current_index + 1
    end
    
    def parse_header(header_line)
        parts =  header_line.partition(":")
        h_key = parts[0].gsub('-', '_')
        h_key = h_key.upcase
        @headers[h_key] = parts[2].strip
        ENV[h_key] = parts[2].strip
    
    end

    def parse_body
      if @current_index < @request_content_array.length
          newarray = @request_content_array[@current_index..-1].collect{|x| x.lstrip}
          @body = newarray.join()
          @body.strip!
          
        # if the method is post parameters are in the body
        if @http_method == "POST" && @body.length > 0
           parse_params(@body)
        end  
      else
        @body = ""
      end
      
    end
    
    def modified_since
      
      if @headers.has_key?('IF_MODIFIED_SINCE')
        Date.parse(@headers['IF_MODIFIED_SINCE'])
      end
    end


    # creates a hash of param pairs and hash is empty when no parameters 
    # TODO put check
    def parse_params(param_str)
      param_pairs = param_str.split('&')
      @params = Hash.new
      param_pairs.each do |pair|
        @params[pair.split('=').first] = pair.split('=').last
      end
    end
 
    def dump_request
      puts "request no #{@@request_no}"
      puts "-------------Request Dump----------------------"
      puts @request_content
      puts "-----------------------------------------------"
      puts "Length of request: #{@request_content.length}"
    end
  end
end
