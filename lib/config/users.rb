require 'base64'
require 'digest'
module WebServer
  class Users
    
    def initialize(file_path)
      @username_password = nil
      @auth_user_file = file_path
      load_user_file
    end
    
    
    
    def valid?(username, password)
      puts @username_password[username]
      puts Digest::SHA1.base64digest(password)
      @username_password[username].strip == Digest::SHA1.base64digest(password).strip
    end
    
    def users
      @username_password.keys
    end
    
    # decode the .htpasswd file to make authorized username-password HashMap 
    def load_user_file
      if File.exists?(@auth_user_file)
        @username_password ||= begin
          username_password = Hash.new
          file_content = File.read(@auth_user_file)
          file_content.each_line do |line|
            if !line.strip.nil? then line_parts = line.split(':') end
            username_password[line_parts[0]] = line_parts[1].gsub!(/{SHA}/, '')
          end 
          username_password
        end
        puts @username_password
      end
     end
     
     
     
  end
end