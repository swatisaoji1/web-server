require_relative 'configuration'

# Parses, stores and exposes the values from the mime.types file
module WebServer
  class MimeTypes < Configuration
    def initialize(mime_file_content)
	super(mime_file_content)
    end
    
    # Returns the mime type for the specified extension
    def for_extension(extension)
      return extension
    end

  end
end
