require "rest-client"
module MojitoImport
  class Session


    def self.get_token(import_scenario_identifier, access_token, session_bucket, operator_identifier: nil, history_group: nil, use_dev_host: false, force_new: false)
      data = { import_scenario_identifier: import_scenario_identifier, session_bucket: session_bucket, operator_identifier: operator_identifier, history_group: history_group, force_new: force_new }

      mojito_host = use_dev_host ? 'http://www.mojito-import.test' : 'https://www.mojito-import.com'

      request = RestClient::Resource.new(mojito_host, accept: :json,content_type: :json, Authorization: "Bearer #{access_token}", verify_ssl: false)

      response = request["api/v1/import_session_token?access_token=#{access_token}"].post(data) { |response, request, result|
        case response.code
        when 200, 201
          return JSON.parse(response)["token"]
        when 500
          return {"error when retrieving token" => response.body.inspect}
        else
          return JSON.parse(response)
        end
      }
    end


  end
end
