# frozen_string_literal: true


RSpec.describe MojitoImport::Report do
  let(:report) { MojitoImport::Report.new('123') }

  describe ".add_data_error" do
    before do
      report.add_data_error('1234', 'name', 'wrong name')
      report.add_data_error('1234', 'name', 'banana name')
      report.add_data_error('1234', 'website', 'WEBSITE BROKEN')
      report.add_data_error('7985', 'name', 'NAME BROKEN')
    end

    it 'adds a data error' do
      expect(report.data_errors).to eq([{"mojitoId" => "1234", "name" => ["wrong name", "banana name"], "website" => ["WEBSITE BROKEN"]}, {"mojitoId"=> "7985","name" => ["NAME BROKEN"]}])
    end

  end

  describe ".add_data_error" do
    before do
      report.add_data_update('1234', 'name', 'before name value')
      report.add_data_update('7985', 'firstname', 'before firstname value', to: "")
       report.add_data_update('7985', 'phone', 'before phone value', to: "after after value")
    end

    it 'adds data updates' do
      expect(report.data_updates).to eq([{"mojitoId"=>"1234", "name"=>{"before"=>"before name value"}}, {"firstname"=>{"after"=>"", "before"=>"before firstname value"},
         "mojitoId"=>"7985",
         "phone"=>[{"after"=>"after after value", "before"=>"before phone value"}]}])
    end

  end

end
