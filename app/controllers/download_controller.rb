class DownloadController < ApplicationController
  before_action :authenticate_user!
  def view
    @subjects = nil
    @student = []
    @sheet = []
    @count = [[]]
    @sno = 0
    @i = 0
    @modelname = params[:batch]
    @semester = params[:semester]
    @branch = @modelname.partition("2").first.upcase
    @batch = Kernel.const_get(@modelname)
    
    @records = SubjectDetail.find_by(branch: @branch, semester: @semester)
    
    for @s in @records.subject do
      @sheet[@i] = Attendancesheet.where(batch: @modelname, subject: @s).last
      @i+=1
    end
    
    @i=0
    @len = @sheet.length
    for j in 0..@len-1 do
      @count[j] = []
    end
    for j in 0..@len-1 do
      if @sheet[j]==nil
        next
      else
        @sheet[j].attendances.each do |att|
          @count[j].push(att.attend_count)
        end
      end
    end
    
    @overall_count = []
    @percent = []
    @students = @batch.all
    for s in @students do
      @student.push(s.roll_no)
      @overall_count.push(0)
      @percent.push(0)
    end
    
    @overall_total = 0
  end
  
  
end
