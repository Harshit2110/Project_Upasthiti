class Attendancesheet
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  has_many :attendances, dependent: :destroy
  accepts_nested_attributes_for :attendances
  field :attendance_on,       type: String
  field :total,               type: Integer, default: 0
  field :batch,               type: String
  field :semester,            type: String
  field :subject,             type: String
  field :teacher_id,          type: String
end
