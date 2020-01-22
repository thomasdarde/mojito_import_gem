require 'json'

module MojitoImport
  class Report
    attr_accessor :object_errors, :request_errors, :data_updates, :import_id

    def initialize(import_id)
      self.import_id = import_id
      self.object_errors = []
      self.request_errors = []
      self.data_updates = []
    end

    def to_json
      {
        "mojitoRequestId" => self.import_id,
        "requestErrors" => self.request_errors,
        "objectErrors" => self.object_errors
      }.to_json
    end

    def add_request_error(error)
      request_errors << error
    end

    def add_data_update(mojito_id, field, from, to: nil)

      hash_element =
        data_updates.detect { |error_hash| error_hash["mojitoObjectId"] == mojito_id }

      update_hash = {"before" => from}
      update_hash["after"] = to unless to.nil?

      if hash_element.nil?
        new_update_hash = { "mojitoObjectId" => mojito_id, field => update_hash }
        data_updates << new_update_hash
      else
        hash_element[field] = update_hash
      end
    end

    def add_object_error(mojito_id, error, field: nil)

      hash_element =
        object_errors.detect { |error_hash| error_hash["mojitoObjectId"] == mojito_id }

      if hash_element.nil?
        hash_element = { "mojitoObjectId" => mojito_id, "general" => [], "fields" => { } }
        object_errors << hash_element
      end

        if field.nil? # it's a general error
          hash_element["general"] << error
        else
          # The field has to be initialized to an array
          # Else we got an error when adding an error to a 2nd field
          hash_element["fields"][field] ||= []
          hash_element["fields"][field] << error
        end
    end

    def find_errors_for_object(mojito_id)
      object_error = object_errors.detect { |data| data["mojitoObjectId"] == mojito_id }
      return if object_error.nil?

      object_error.except("mojitoObjectId")
    end
  end
end
