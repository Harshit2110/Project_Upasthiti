class Teacher
  include Mongoid::Document
  field :first_name,  type: String
  field :last_name,   type: String
  field :phone_no,    type: Integer
  field :email,       type: String
  
end
