class ResumeController < ApplicationController
  require_relative '../services/gpt3_service'
  @tailored_resume_for_download = ""

  def new
    @resume = Resume.new
  end

  def create
    # if params[:resume][:resume_text].present?
    #   puts "Resume Text: #{params[:resume][:resume_text]}"
    # end
    @resume = Resume.new(resume_params)
    @resume.title = params[:resume][:resume_text]
    if @resume.save
      # puts "Uploaded resume title: #{@resume.title}"
      flash[:notice] = "Resume uploaded successfully."
      flash[:alert] = "Warning: you have not yet tailored your resume for editing or downloading"
      redirect_to uploaded_path
    else
      render 'new'
    end

    # @last_resume = Resume.last
    # puts @last_resume.inspect
  end

  def tailor
    description = params[:description]
    # puts description

    if description == ""
      flash[:alert] = "Warning: you have not tailored your resume for editing or downloading"
      flash[:notice] = "No description, try again"
    else
      flash[:alert] = "Success! You can preview or download"
      flash[:notice] = nil

      @last_resume = Resume.last

      # Change resume with AI
      @prompt = "Tailor the following resume to match the job description. Don't lie, but rather enhance the resume to just fit the description better. Also, try to keep each line length roughly the same and the number of lines roughly the same:\n\nJob Description: #{description}\n\nResume: #{@last_resume.title} \n\nTailored Resume:"
      @tailored_resume = Gpt3Service.call(@prompt, 'gpt-3.5-turbo-0301')
      # puts "THIS IS WHAT GPT IS RETURNING:"
      # puts @tailored_resume

      # @resume = Resume.new(resume_text: @tailored_resume) # Create a new resume with the tailored content
      # @resume = Resume.new

      # @resume.id = last_resume.id + 1

      # puts "Value of @tailored_resume: #{@tailored_resume}"
      # Assign @tailored_resume to @resume.resume_text
      @last_resume.title = @tailored_resume
      @last_resume.resume_text = @tailored_resume
      @last_resume.save

      # if @last_resume.save
      #   # Successfully saved
      #   # puts "successfully saved"
      # else
      #   # Handle validation errors
      #   # puts @last_resume.errors.full_messages
      # end

      # puts "this is the new resume!!"
      # puts @last_resume.inspect
      # l_resume = Resume.order(id: :desc).first
      # puts l_resume.inspect

    end
    redirect_to uploaded_path
  end

  def download
    tailored_resume = Resume.last # Get the last tailored resume
    # attributes_hash = tailored_resume.attributes
    # attributes_hash.each do |attribute, value|
    #   puts "#{attribute}: #{value}"
    # end
    if tailored_resume
      # puts 'here'
      # puts tailored_resume.title
      # puts 'here'
      send_data tailored_resume.title, filename: 'tailored_resume.txt', type: 'text/plain', disposition: 'attachment'
      # puts "Tailored resume exists"
    else
      flash[:alert] = "No tailored resume is available for download."
      # puts "ERROR: No tailored resume found"
      redirect_to uploaded_path
    end
  end

  def editor
    @last_resume = Resume.last
    if @last_resume
      @editor_helper = @last_resume.title
    else
      @editor_helper = "No Resume"
    end
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
    
    @last_resume = @resume
    @tailored_resume = @resume

    flash[:notice] = "Success! Resume Updated"
    redirect_to uploaded_path
  end
  
  def cancel
    flash[:notice] = "Your resume was not changed"
    redirect_to uploaded_path
  end

  def resume_params
    params.require(:resume).permit(:attachment, :resume_text, :file, :filename) # Include :resume_text in permitted params
  end
end