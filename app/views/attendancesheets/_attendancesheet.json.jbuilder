json.extract! attendancesheet, :id, :created_at, :updated_at
json.url attendancesheet_url(attendancesheet, format: :json)
