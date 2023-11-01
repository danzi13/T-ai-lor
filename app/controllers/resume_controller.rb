class ResumeController < ApplicationController

  require_relative '../services/gpt3_service'
  def new
    @resume = Resume.new
  end

  def create
    @resume = Resume.new(resume_params)
    if @resume.save
      puts "Uploaded resume title: #{@resume.title}"
      #puts "Uploaded resume file: #{@resume.file.url}"
      flash[:notice] = "Resume uploaded successfully."
      flash[:alert] = "Warning: you have not yet tailored your resume for editing or downloading"
      redirect_to uploaded_path
    else
      render 'new'
    end
  end

  def tailor

    description = params[:description]
    puts description

    if description == ""
      flash[:alert] = "Warning: you have not tailored your resume for editing or downloading"
      flash[:notice] = "No description, try again"
    else
      flash[:alert] = "Success! You can preview or download"
      flash[:notice] = nil
      #Change resume with AI

      tailored_resume = Gpt3Service.generate_tailored_resume(description, @resume.title)

      puts tailored_resume


    end
    redirect_to uploaded_path
  end

  def download
    # If not tailored then 
    #flash[:notice] = 'No description uploaded, download failed(????)'
    #flash[:alert] = "Warning: you have not tailored your resume for editing or downloading"
    #redirect_to uploaded_path

    #else
    #send_file '/path/to.zip'

    redirect_to uploaded_path
  end 

  private

  def resume_params
    params.require(:resume).permit(:title, :attachment)
  end
end

