class Dummy
  include Mongoid::Document
  #field :selected_model, type: String
  #field :file, type: String
  
  def self.import(batch,file)
    @batch = Kernel.const_get(batch)
    spreadsheet = Roo::Spreadsheet.open(file.path)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      record = nil
      if @batch == Teacher
        record = @batch.find_by(email: row["email"])
      else
        record = @batch.find_by(univ_roll_no: row["univ_roll_no"])
      end
      if(record == nil)
        record = @batch.new
      end
      record.attributes = row.to_hash
      record.save!
    end
  end
end
