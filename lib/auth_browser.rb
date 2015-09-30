
require 'base64'
require 'digest/sha1'

module WebServer
  class AuthBrowser
    
    def initialize(res, access_file_name, doc_root)
      @res = res
      @path = res.resolved_path
      @uri = res.final_uri
      @access_file = access_file_name
      @doc_root = doc_root
      @access_file_path = nil
      
    end
    
    def protected?
      puts @uri
      sub_folders = @uri.split('/')
      sub_folders.reject!{|x| x == ""}
      if File.file?(@path) then sub_folders.pop end
      start_path = @doc_root    
      sub_folders.each do |sub_folder|
        access_file_path = start_path << sub_folder << '/' << @access_file
        if File.exists?(access_file_path)
          @access_file_path  ||= access_file_path
          return true
        end
      end
      false
    end
    
    def has_auth_head?
      auth_head = @res.request.headers["AUTHORIZATION"]
      !auth_head.nil?
    end
    
    def authorized?
      auth_head = @res.request.headers["AUTHORIZATION"]
      if !auth_head.nil?
        auth_head = auth_head.gsub!('Basic', '')
        user_pass = Base64.decode64(auth_head).split(':')
        content = File.read(@access_file_path)
        ht = Htaccess.new(content)
        user = Users.new(ht.auth_user_file)
        authorized = user.valid?(user_pass[0], user_pass[1])
        return authorized
      end
      false
    end
    
    def htaccess_file
  
    end
    
 
    def decrypt_access_string( access_string )
      
    end
    
    
    def find_access_files
      
    end
    
  end
end