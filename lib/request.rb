# The Request class encapsulates the parsing of an HTTP Request
module WebServer
  class Request
    attr_accessor :http_method, :uri, :version, :headers, :body, :params
    
    
    # Request creation receives a reference to the socket over which
    # the client has connected
    def initialize(socket)
      # Perform any setup, then parse the request
      @current_index = 0
      #@request_content = String.new("GET /?param1=one HTTP/1.1\r\nHost: localhost\r\nContent-Length: 40\n  this is part of previous header\r\n \r\nThis is the body.\r\nWith multiple lines...")
      @request_content = socket
      @request_content_array = Array.new
      @request_content.each_line do |line|
        @request_content_array.push(line)
      end
      @length_con = @request_content_array.length
      @headers = Hash.new
      parse
    end

    # I've added this as a convenience method, see TODO (This is called from the logger
    # to obtain information during server logging)
    def user_id
      # TODO: This is the userid of the person requesting the document as determined by 
      # HTTP authentication. The same value is typically provided to CGI scripts in the 
      # REMOTE_USER environment variable. If the status code for the request (see below) 
      # is 401, then this value should not be trusted because the user is not yet authenticated.
      '-'
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
      if @current_index < @request_content_array.length  then
        newarray = @request_content_array[@current_index..-1].collect{|x| x.lstrip}
        @body = newarray.join()
        @body.strip!
      else
        @body = ""
      end
      puts 'inspecting ..@headers'
      puts @headers.inspect
      puts '========'
    end


    # The following lines provide a suggestion for implementation - feel free
    # to erase and create your own...
    
    def space_in_beginning?
      !!(@request_content_array[@current_index] =~ /^\s/)
    end
    
    def blank_line?
        @request_content_array[@current_index].strip == ""  
    end
    
    
    def next_line
    end

  
    def parse_request_line
       @http_method, url, @version = @request_content_array[0].split
       split_url = url.partition("?")
       @uri = split_url[0]
       parse_params(split_url[2])
       @current_index = @current_index + 1
    end
    
    def parse_header(header_line)
        parts =  header_line.partition(":")
        h_key = parts[0].sub('-', '_')
        h_key = h_key.upcase
        @headers[h_key] = parts[2].strip
        ENV[h_key] = parts[2].strip
        puts ENV.inspect
        puts @headers.inspect
    end

    def parse_body(body_line)
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
 
    
  end
end
