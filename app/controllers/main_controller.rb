class MainController < ApplicationController
  before_action :authenticate_user!
  require 'uri'
  
  def dashboard
    if(current_user.access_right == 'admin' || current_user.access_right == 'teacher')
      @model_paths = Dir["#{Rails.root}/app/models/**/*.rb"]
      @sanitized_model_paths = @model_paths.map { |path| path.gsub(/.*\/app\/models\//, '').gsub('.rb', '') }
      @sanitized_model_paths.delete("user")
      @sanitized_model_paths.delete("dummy")
      @sanitized_model_paths.delete("subject_detail")
      @sanitized_model_paths.delete("attendance")
      @sanitized_model_paths.delete("attendancesheet")
      @model_constants = @sanitized_model_paths.map do |path|
          path.split('/').map { |token| token.camelize }.join('::').constantize
      end
    end
    if(current_user.access_right == 'teacher')
      @teacher = Teacher.find_by(email: current_user.email)
    end
    if(current_user.access_right != 'admin' and current_user.access_right != 'teacher')
      @modelName = current_user.access_right
      @batch = Kernel.const_get(@modelName)
      @urn = current_user.email.partition('@').first
      @student = @batch.find_by(univ_roll_no: @urn)
    end
  end
  
  def import
    Dummy.import(params[:selected_model], params[:file])
  
    @modelName = params[:selected_model]
    @batch = Kernel.const_get(@modelName)
    
    if (@batch == Teacher)
      @records = @batch.all
      for @record in @records
        @pass = Devise.friendly_token.first(8)
        @email = @record.email
        @user = User.new(email: @email,password: @pass, password_confirmation: @pass, access_right: "teacher")
        if @user.valid?
          @user.save
          #send login details to teacher
          CredentialMailer.info_email(@user,@pass).deliver
        else
          next
        end
      end
      
    else
      @records = @batch.all
      @concate = "@ymca.in"
      for @record in @records
        @pass= @record.univ_roll_no
        @email = @record.univ_roll_no.to_s + @concate
        @user = User.new(email: @email,password: @pass, password_confirmation: @pass, access_right: @modelName)
        if @user.valid?
          @user.save
        else
          next
        end
      end
    end
    
    redirect_to root_url, notice: 'Records Imported.'
  end

end



