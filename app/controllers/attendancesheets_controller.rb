class AttendancesheetsController < ApplicationController
  before_action :set_attendancesheet, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  $previous_status = []
  # GET /attendancesheets
  # GET /attendancesheets.json
  def index
    @attendancesheets = Attendancesheet.where(teacher_id: current_user.id).sort(["batch","aesc"])
    @attendancesheets.sort(["subject", "aesc"])
    @attendancesheets.sort(["semester", "aesc"])
    @attendancesheets.sort(["date", "desc"])
  end

  # GET /attendancesheets/1
  # GET /attendancesheets/1.json
  def show
    @attendancesheet = Attendancesheet.find(params[:id])
    @sno = 0
  end

  # GET /attendancesheets/new
  def new
    @subjects = nil
    @sno = 0
    @student = []
    @modelname = params[:batch]
    @semester = params[:semester]
    
    @branch = @modelname.partition("2").first.upcase
    @batch = Kernel.const_get(@modelname)
    @records = SubjectDetail.where(branch: @branch, semester: @semester)
    
    for r in @records do
      @subjects = r.subject
    end
    
    @students = @batch.all
    for s in @students do
      @student.push(s.roll_no)
    end
    @attendancesheet = Attendancesheet.new
    @student.length.times{@attendancesheet.attendances.build}
  end

  # GET /attendancesheets/1/edit
  def edit
    @attendancesheet = Attendancesheet.find(params[:id])
    @subjects = nil
    @sno = 0
    @student = []
    @modelname = @attendancesheet.batch
    @semester = @attendancesheet.semester
    @branch = @modelname.partition("2").first.upcase
    @batch = Kernel.const_get(@modelname)
    @records = SubjectDetail.where(branch: @branch, semester: @semester)
    for r in @records do
      @subjects = r.subject
    end
    
    @students = @batch.all
    for s in @students do
      @student.push(s.roll_no)
    end
    
    @attendancesheet.attendances.each do |att|
      $previous_status.push(att.attend_status)
    end
  end

  # POST /attendancesheets
  # POST /attendancesheets.json
  def create
    @attendancesheet = Attendancesheet.new(attendancesheet_params)
    
    @aForTotal = Attendancesheet.where(batch: @attendancesheet.batch, subject: @attendancesheet.subject).last
    if @aForTotal == nil
      @attendancesheet.total = 1
    else
      @attendancesheet.total = @aForTotal.total + 1
    end
    
    respond_to do |format|
      if @attendancesheet.save
        format.html { redirect_to @attendancesheet, notice: 'Attendancesheet was successfully created.' }
        format.json { render :show, status: :created, location: @attendancesheet }
      else
        format.html { render :new }
        format.json { render json: @attendancesheet.errors, status: :unprocessable_entity }
      end
    end
    
    @array = []
    @i = -1
    if @aForTotal == nil
      @attendancesheet.attendances.each do |att|
        if att.attend_status==true
          att.attend_count+=1
        end
        att.save
      end
    else
      @aForTotal.attendances.each do |att|
        @array.push(att.attend_count)      
      end
      @attendancesheet.attendances.each do |att|
        if att.attend_status==true
          att.attend_count = @array[@i+=1] + 1
        end
        att.save
      end
    end
    
  end

  # PATCH/PUT /attendancesheets/1
  # PATCH/PUT /attendancesheets/1.json
  def update
    respond_to do |format|
      if @attendancesheet.update(attendancesheet_params)
        format.html { redirect_to @attendancesheet, notice: 'Attendancesheet was successfully updated.' }
        format.json { render :show, status: :ok, location: @attendancesheet }
      else
        format.html { render :edit }
        format.json { render json: @attendancesheet.errors, status: :unprocessable_entity }
      end
    end
    @i=-1
    @attendancesheet.attendances.each do |att|
      if att.attend_status == true and $previous_status[@i+=1] == false
        att.attend_count+=1
      end
      att.save
    end
  end

  # DELETE /attendancesheets/1
  # DELETE /attendancesheets/1.json
  def destroy
    @attendancesheet.destroy
    respond_to do |format|
      format.html { redirect_to attendancesheets_url, notice: 'Attendancesheet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attendancesheet
      @attendancesheet = Attendancesheet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attendancesheet_params
      params.fetch(:attendancesheet, {}).permit(:attendance_on, :batch, :semester, :subject, :teacher_id, attendances_attributes: [:id, :roll_no, :attend_status])
    end
end
