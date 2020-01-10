require "rest-client"
module MojitoImport
  class Session
    attr_accessor :access_token, :session_bucket, :import_scenario_identifier

    def self.get_token(import_scenario_identifier, access_token, session_bucket)
      data = { import_scenario_identifier: import_scenario_identifier, session_bucket: session_bucket }
      session_token_endpoint = "http://www.mojito-import.test/api/v1/import_session_token"

      request = RestClient::Resource.new('http://www.mojito-import.test', accept: :json,content_type: :json, Authorization: "Bearer #{access_token}", verify_ssl: false)

      response = request["api/v1/import_session_token?access_token=#{access_token}"].post(data) { |response, request, result|
        case response.code
        when 200, 201
          return JSON.parse(response)["token"]
        else
          return JSON.parse(response)
        end
      }
    end
  end
end
