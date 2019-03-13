require "mojito_import/version"
require "rest-client"
module MojitoImport
  class Importer
    attr_accessor :import_scenario_identifier, :access_token, :operator
    attr_accessor :additional_row_data, :button_name
    attr_accessor :mojito_host

    def self.create(import_scenario_identifier:  ,
                    operator: nil,
                    access_token: , additional_row_data: {},
                    button_name: "Upload your file",
                    mojito_host: "https://mojito-import.herokuapp.com")
      importer = MojitoImport::Importer.new
      importer.access_token = access_token
      importer.additional_row_data = additional_row_data
      importer.button_name = button_name
      importer.mojito_host = mojito_host
      importer.import_scenario_identifier = import_scenario_identifier
      importer.operator = operator
      importer
    end

    def display_iframe
      safari_workaround = %Q{<script>
var is_safari = navigator.userAgent.indexOf("Safari") > -1;
// Chrome has Safari in the user agent so we need to filter (https://stackoverflow.com/a/7768006/1502448)
var is_chrome = navigator.userAgent.indexOf('Chrome') > -1;
if ((is_chrome) && (is_safari)) \{is_safari = false;\}
          if (is_safari) \{
              // See if cookie exists (https://stackoverflow.com/a/25617724/1502448)
              if (!document.cookie.match(/^(.*;)?\s*fixed\s*=\s*[^;]+(.*)?$/)) \{
                  // Set cookie to maximum (https://stackoverflow.com/a/33106316/1502448)
                  document.cookie = 'fixed=fixed; expires=Tue, 19 Jan 2038 03:14:07 UTC; path=/';
                  var current_path = encodeURI(window.location);
                  window.location.replace("#{mojito_host}/_safari_fix.html?return_path="+current_path);
                \}
                \}
                </script>}

                %Q{#{safari_workaround}<iframe src="#{iframe_src}" style= 'width: 100%; height: 600px' />}
              end



              private

              def iframe_src
                # On query le serveur avec cet url
                # IL renvoi un id crypté de l'objet "import"

                # pour le moment l'id n'est pas crypté ..
                # Il faut maintenant créer l'iframe correspondant en bougeant du code

                "#{mojito_host}/imports/#{import_id}/iframe?access_token=#{access_token}&operator=#{operator}"
              end

              def import_id
                # ?access_token=#{access_token}&?import_scenario_identifier=sigilium-users
                data = {additional_row_data: additional_row_data, import_scenario_identifier: self.import_scenario_identifier, operator: self.operator}
                # RestClient::Resource.new( , verify_ssl: false, log: Logger.new(STDOUT)).post "https://mojito-import.test/api/v1/new_import", data.to_json, {content_type: :json, accept: :json, :Authorization => "Bearer #{access_token}"}

                remote_endpoint_url = "#{mojito_host}/api/v1/new_import"
                RestClient::Resource.new( remote_endpoint_url, verify_ssl: false, log: Logger.new(STDOUT)).post data.to_json, {content_type: :json, accept: :json, :Authorization => "Bearer #{access_token}"}
              end
              end
              # Your code goes here...
              end
