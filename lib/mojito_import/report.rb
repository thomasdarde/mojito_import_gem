module MojitoImport
  class Report
    attr_accessor :data_errors, :general_errors, :data_updates, :import_id

    def initialize(import_id)
      self.import_id = import_id
      self.data_errors = []
      self.general_errors = []
      self.data_updates = []
    end

    def add_general_error(error)
      general_errors << error
    end

    def add_data_update(mojito_id, field, from, to: nil)
      # reload!; report = MojitoImport::Report.new('1234'); report.add_data_error('123', 'name', 'your name sucks')
      hash_element =
        data_updates.detect { |error_hash| error_hash["mojitoId"] == mojito_id }

      update_hash = {"before" => from}
      update_hash["after"] = to unless to.nil?

      if hash_element.nil?
        new_update_hash = { "mojitoId" => mojito_id, field => update_hash }
        data_updates << new_update_hash
      else
        hash_element[field] = update_hash
      end
    end

    def add_data_error(mojito_id, field, error)
      # reload!; report = MojitoImport::Report.new('1234'); report.add_data_error('123', 'name', 'your name sucks')
      hash_element =
        data_errors.detect { |error_hash| error_hash["mojitoId"] == mojito_id }

      if hash_element.nil?
        new_error_hash = { "mojitoId" => mojito_id, field => [error] }
        data_errors << new_error_hash
      else
        hash_element[field] ||= []
        hash_element[field] << error
      end
    end

    def find_errors_for_object(mojito_id)
      data_error = data_errors.detect { |data| data["mojitoId"] == mojito_id }
      return if data_error.nil?

      data_error.except("mojitoId")
    end
  end
end
