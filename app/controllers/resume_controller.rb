require 'pdf-reader'

class ResumeController < ApplicationController
  require_relative '../services/gpt3_service'
  @tailored_resume_for_download = ""

  def new
    @resume = Resume.new
  end


 def create
    # puts "Made it to create"
    @resume = Resume.new(resume_params)
    if params[:resume][:resume_text].present?
      @resume.title = params[:resume][:resume_text]
    else
      @resume.title = ''
    end

    # puts params[:resume]
    # if params[:file].present?
    #   @pdf_reader = PDF::Reader.new(params[:attachment].tempfile.path)
    #   puts @pdf_reader
    # else
    #   puts "No file attached."
    # end

    @pdf_reader = PDF::Reader.new(params[:resume][:attachment].tempfile.path)
    puts @pdf_reader

    @pdf_reader.pages.each do |page|
      puts 'inside for loop for pdf-reader'
      puts page.text
      @resume.title += page.text
    end
    
    puts @resume.title

    if @resume.save
      # puts "Saves correctly"
      # puts "Uploaded resume title: #{@resume.title}"
      flash[:notice] = "Resume uploaded successfully."
      flash[:alert] = "Warning: you have not yet tailored your resume for editing or downloading"
      redirect_to uploaded_path
    else
      # puts "In the else statement"
      flash[:error] = "Failed to upload resume. Please try again."
      render 'new'
    end
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
      @prompt = "Tailor the following resume to match the job description. Don't lie, but rather enhance the resume to just fit the description better. Also, try to keep each line length roughly the same and the number of lines roughly the same from the original resume to the tailored resume. AGAIN, DO NOT JUST MAKE UP EXPERIENCES. :\n\nJob Description: #{description}\n\nResume: #{@last_resume.title} \n\nTailored Resume:"
      # @prompt = "Here is a resume. Return to me the same resume but parsed into different sections. Between each section put 3 & symbols. DO NOT CHANGE ANYTHING ABOUT THE RESUME, EXCEPT ADDING THE & SYMBOLS AND DO NOT RETURN ANY NEW LINE CHARACTERS. Resume: #{@last_resume.title}. \n\n Resume Parsed: "
      @tailored_resume = Gpt3Service.call(@prompt, 'gpt-3.5-turbo-0301')
      # @sections = @tailored_resume.split('&&&&&')
      # # puts "THIS IS WHAT GPT IS RETURNING:"

      # @tailored_resume = ''
      
      # for s in @sections
      #   puts 'in the loop'
      #   @s = s
      #   @prompt = "Here is a resume section. Tailor the following section to match the job description. Don't lie in the tailored resume, but rather enhance the original resume to just fit the description better. Also, try to keep each line length roughly the same and the number of lines roughly the same as the original resume section in the new resume section. :\n\nJob Description: #{description}\n\nResume section: #{@s} \n\nTailored Resume: "
      #   @tailored_section = Gpt3Service.call(@prompt, 'gpt-3.5-turbo-0301')
      #   @tailored_resume += @tailored_section
      # end



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
  @resume = Resume.new(resume_params)

  if @file.present?
    if @file.content_type == 'application/pdf'
       reader = PDF::Reader.new(@file.path)
       @resume.resume_text = reader.pages.map(&:text).join("\n")
    else
       @resume.resume_text = "Unsupported file format: #{@file.content_type}"
    end
  end

  if @resume.save
    flash[:notice] = "Success! Resume Uploaded"
    redirect_to uploaded_path
  else
    flash[:error] = "Failed to upload resume. Please try again."
    render :new
  end
end

  def cancel
    flash[:notice] = "Your resume was not changed"
    redirect_to uploaded_path
  end

  def resume_params
    params.require(:resume).permit(:attachment, :resume_text, :file, :filename) # Include :resume_text in permitted params
  end
end
