class ResumeController < ApplicationController
  require_relative '../services/gpt3_service'
  @tailored_resume_for_download = ""

  def new
    @resume = Resume.new
  end

  def create
    if params[:resume][:resume_text].present?
      puts "Resume Text: #{params[:resume][:resume_text]}"
    end
    @resume = Resume.new(resume_params)
    if @resume.save
      puts "Uploaded resume title: #{@resume.title}"
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

      # Change resume with AI
      @prompt = "Tailor the following resume to match the job description:\n\nJob Description: #{description}\n\nResume: skills: java, python \n\nTailored Resume:"
      @tailored_resume = Gpt3Service.call(@prompt, 'gpt-3.5-turbo-0301')
      puts "THIS IS WHAT GPT IS RETURNING:"
      puts @tailored_resume

      # @resume = Resume.new(resume_text: @tailored_resume) # Create a new resume with the tailored content
      @resume = Resume.new
      last_resume = Resume.last

      @resume.id = last_resume.id + 1

      puts "Value of @tailored_resume: #{@tailored_resume}"
      # Assign @tailored_resume to @resume.resume_text
      @resume.title = @tailored_resume
      # Check the value of @resume.resume_text after assignment
      puts "Value of @resume.resume_text after assignment: #{@resume.resume_text}"
      @resume.save
      puts "this is the new resume!!"
      puts @resume.inspect
      last_resume = Resume.last
      puts last_resume.inspect

    end
    redirect_to uploaded_path
  end

  def download
    tailored_resume = Resume.last # Get the last tailored resume
    attributes_hash = tailored_resume.attributes
    attributes_hash.each do |attribute, value|
      puts "#{attribute}: #{value}"
    end
    if tailored_resume
      puts 'here'
      puts tailored_resume.title
      puts 'here'
      send_data tailored_resume.title, filename: 'tailored_resume.txt', type: 'text/plain', disposition: 'attachment'
      puts "Tailored resume exists"
    else
      flash[:alert] = "No tailored resume is available for download."
      puts "ERROR: No tailored resume found"
      redirect_to uploaded_path
    end
  end

  def editor
    @editor_helper = "hi"
    if @tailored_resume == ""
      @title_helper = 'tailored_resume.txt'
      @editor_helper = @tailored_resume
    else
      flash[:notice] = "No resume was tailored"
    end
  end

  def save
    #puts params[:resume]
    @resume = Resume.new
    @resume.title = params[:resume]
    @resume.save
    flash[:notice] = nil
    redirect_to uploaded_path
  end


private

  def resume_params
    params.require(:resume).permit(:attachment, :resume_text) # Include :resume_text in permitted params
    # params.permit(:resume, :attachment, :resume_text)
  end
end