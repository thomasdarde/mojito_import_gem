# frozen_string_literal: true


RSpec.describe MojitoImport::Report do
  let(:report) { MojitoImport::Report.new('123') }

  describe ".add_request_error" do
    before do
      report.add_request_error('The whole request creates an error')
    end

    it 'generates a valid report' do
      expect(report.to_json).to eq(%Q{{"mojitoRequestId":"123","requestErrors":["The whole request creates an error"],"objectErrors":[],"objectUpdates":[]}})
    end
  end

  describe ".add_object_error" do
    before do
      report.add_object_error('1234', 'wrong name', field: 'name')
      report.add_object_error('1234', 'banana name', field: 'name')
      report.add_object_error('1234', 'WEBSITE BROKEN', field: 'website')
      report.add_object_error('7985', 'NAME BROKEN', field: 'name')

    end


    it 'adds a data error' do
      expect(report.object_errors).to eq([{ "fields" => {"name" => ["wrong name", "banana name"],"website" => ["WEBSITE BROKEN"]}, "general"=>[], "mojitoObjectId" => "1234", }, {"mojitoObjectId"=> "7985", "general"=>[],"fields" => {"name" => ["NAME BROKEN"]}}])
    end

    it 'generates a valid report' do
      expect(report.to_json).to eq(%Q{{"mojitoRequestId":"123","requestErrors":[],"objectErrors":[{"mojitoObjectId":"1234","general":[],"fields":{"name":["wrong name","banana name"],"website":["WEBSITE BROKEN"]}},{"mojitoObjectId":"7985","general":[],"fields":{"name":["NAME BROKEN"]}}],"objectUpdates":[]}})
    end

 describe ".general error" do
    let(:report2) { MojitoImport::Report.new('12345') }

    before do
      report2.add_object_error('7985', 'general BROKEN')
    end


    it 'adds a data error' do
      expect(report2.object_errors).to eq([ {"fields"=>{}, "general"=>["general BROKEN"], "mojitoObjectId"=>"7985"}])
    end

    it 'generates a valid report' do
   #   puts report2.to_json
      expect(report2.to_json).to eq(%Q{{"mojitoRequestId":"12345","requestErrors":[],"objectErrors":[{"mojitoObjectId":"7985","general":["general BROKEN"],"fields":{}}],"objectUpdates":[]}})
    end

  end

  end

  describe ".add_object_update" do
    before do
      report.add_object_update('1234', 'name', 'before name value')
      report.add_object_update('7985', 'firstname', 'before firstname value', to: "")
      report.add_object_update('7985', 'phone', 'before phone value', to: "after after value")
    end

    it 'adds data updates' do
      expect(report.object_updates).to eq([
        {
          "mojitoObjectId"=>"1234",
          "name"=>{"before"=>"before name value"}
        },
        {
          "mojitoObjectId"=>"7985",
          "firstname"=> { "after"=>"", "before"=>"before firstname value" },
          "phone"=> { "after"=>"after after value", "before"=>"before phone value"}
        }
      ])
    end

  end

end
