class Attendance
  include Mongoid::Document
  belongs_to :attendancesheet
  field :roll_no, type: String
  field :attend_status, type: Boolean
  field :attend_count, type: Integer, default: 0
end
