require "mojito_import/version"

module MojitoImport
  class Iframe
    def self.get(name: name, access_token: access_token)
      "https://mojito-import.test/iframes/s/#{name}?access_token=#{access_token}"
    end
  end
  # Your code goes here...
end
