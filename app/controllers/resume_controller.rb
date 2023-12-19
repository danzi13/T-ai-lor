require 'pdf-reader'
require 'prawn'

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
    elsif params[:resume][:attachment].present?
      @resume.title = ' '
      # @pdf_reader = PDF::Reader.new(params[:resume][:attachment].tempfile.path)
      # @pdf_reader.pages.each do |page|
      #   @resume.title += page.text
      # end

      begin
        @pdf_reader = PDF::Reader.new(params[:resume][:attachment].tempfile.path)
        @pdf_reader.pages.each
        @pdf_reader.pages.each do |page|
          @resume.title += page.text #this works, i tested with puts
        end
      rescue PDF::Reader::MalformedPDFError => e
        flash[:error] = "Error parsing PDF: #{e.message}"
        redirect_to resume_path and return
      end

    else
      @resume.title = 'None, Error'
    end

    # puts params[:resume]
    # if params[:file].present?
    #   @pdf_reader = PDF::Reader.new(params[:attachment].tempfile.path)
    #   puts @pdf_reader
    # else
    #   puts "No file attached."
    # end

    # puts @resume

    if @resume.save
      # puts "Saves correctly"
      # puts "Uploaded resume title: #{@resume.title}"
      flash[:notice] = "Resume uploaded successfully."
      flash[:alert] = "Warning: you have not yet tailored your resume for editing or downloading"
      redirect_to uploaded_path
    else
      # puts "In the else statement"
      # flash[:error] = "Failed to upload resume. Please try again."
      # flash[:alert] = "Failed to upload resume. Please try again."
      # flash[:notice] = "Failed to upload resume. Please try again."
      # redirect_to resume_path
      render 'new'
    end
  end

 def tailor
    description = params[:description]

    if description == ""
      flash[:alert] = "Warning: you have not tailored your resume for editing or downloading"
      flash[:notice] = "No description, try again"
    else
      flash[:alert] = "Success! You can preview or download"
      flash[:notice] = nil

      @last_resume = Resume.last

      # Change resume with AI
      @prompt = "Tailor the following resume to match the job description. Don't lie, but rather enhance the resume to just fit the description better. Also, try to keep each line length roughly the same and the number of lines roughly the same from the original resume to the tailored resume. AGAIN, DO NOT JUST MAKE UP EXPERIENCES. :\n\nJob Description: #{description}\n\nResume: #{@last_resume.title} \n\nTailored Resume:"
      @tailored_resume = Gpt3Service.call(@prompt, 'gpt-3.5-turbo-0301')

      @last_resume.title = @tailored_resume.gsub('\n', "\n")
      @last_resume.resume_text = @tailored_resume.gsub('\n', "\n")
      @last_resume.save

    end
    redirect_to uploaded_path
  end


def download
  tailored_resume = Resume.last

  if tailored_resume
    pdf_content = generate_pdf(tailored_resume.resume_text)
    if pdf_content.present?
      send_data pdf_content, filename: 'tailored_resume.pdf', type: 'application/pdf', disposition: 'attachment'
    else
      flash[:alert] = "Error generating PDF content."
      redirect_to uploaded_path
    end
  else
    flash[:alert] = "No tailored resume is available for download."
    redirect_to uploaded_path
  end
end

def generate_pdf(content)
  pdf = Prawn::Document.new
  pdf.text content
  pdf_content = pdf.render
  pdf_content
end 
 
def editor
  @resume = Resume.last || Resume.new
  @editor_helper = @resume.resume_text || "No Resume"
  
  if !@tailored_resume.present?
  #   @title_helper = 'tailored_resume.txt'
  #   @editor_helper = @tailored_resume
  # else
    flash[:notice] = "No resume was tailored"
  end
end

def save
  @resume = Resume.last

  if @resume.update(resume_params)
    flash[:notice] = "Success! Resume Updated"
    redirect_to uploaded_path
  else
    # flash[:error] = "Failed to update resume. Please try again."
    render :editor
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
