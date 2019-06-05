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

end
