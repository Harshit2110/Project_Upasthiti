class SubjectDetail
  include Mongoid::Document
  field :branch,      type: String
  field :semester,    type: Integer
  field :subject,     type: Array,  default: []
end
