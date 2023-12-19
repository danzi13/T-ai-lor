require 'rails_helper'
require 'pdf-reader'
require 'prawn'

RSpec.describe ResumeController, type: :controller do
  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe 'POST #create' do
    context 'when valid parameters are provided' do 
    it 'creates a new resume with a PDF file and saves it successfully' do
        file_path = Rails.root.join('spec', 'sample_resume.pdf')
        file = fixture_file_upload(file_path, 'application/pdf')

        pdf_reader_double = double('pdf_reader')
        allow(PDF::Reader).to receive(:new).and_return(pdf_reader_double)

        # Stubbing the pages method to return an array of double pages
        allow(pdf_reader_double).to receive(:pages).and_return([double('page', text: 'Page 1 content'), double('page', text: 'Page 2 content')])

        expect do
          post :create, params: { resume: { attachment: file } }
        end.to change { Resume.count }.by(1)

        expect(Resume.last.title).to eq(' Page 1 contentPage 2 content')
        expect(response).to redirect_to(uploaded_path)
        expect(flash[:notice]).to eq('Resume uploaded successfully.')
        expect(flash[:alert]).to eq('Warning: you have not yet tailored your resume for editing or downloading')
      end
  end

    context 'when invalid parameters are provided' do
      it 'renders the new template on failure' do
        post :create, params: { resume: { attachment: nil } }
        expect(response).to render_template('new')
        expect(flash[:error]).to eq('Failed to upload resume. Please try again.')
        expect(flash[:notice]).to be_nil
      end
    end
  end

  describe 'POST #tailor' do
    it 'redirects to uploaded_path' do
      post :tailor, params: { description: 'Job description' }
      expect(response).to redirect_to(uploaded_path)
    end

    it 'sets flash messages when description is empty' do
      post :tailor, params: { description: '' }
      expect(flash[:alert]).to eq('Warning: you have not tailored your resume for editing or downloading')
      expect(flash[:notice]).to eq('No description, try again')
      expect(response).to redirect_to(uploaded_path)
    end
    let(:description) { 'Your job description goes here' }

    it 'tailors the resume sections based on job description' do
      allow(Gpt3Service).to receive(:call).and_return("Section 1 &&& Section 2 &&& Section 3")

      post :tailor, params: { description: description }

      expect(response).to have_http_status(:success)
      expect(assigns(:sections)).to eq(['Section 1 ', ' Section 2 ', ' Section 3'])
      expect(assigns(:tailored_resume)).to include('New Tailored Section')
    end

    it 'handles sections without skills, work, or experience' do
      allow(Gpt3Service).to receive(:call).and_return("Section without key phrases")

      post :tailor, params: { description: description }

      expect(response).to have_http_status(:success)
      expect(assigns(:sections)).to eq(['Section without key phrases'])
      expect(assigns(:tailored_resume)).to include('Section without key phrases')
    end
  end

  describe 'GET #download' do
    it 'downloads the tailored resume' do
      tailored_resume = instance_double('Resume', title: 'Sample Tailored Resume')
      allow(Resume).to receive(:last).and_return(tailored_resume)

      get :download
      expect(response.body).to include('Sample Tailored Resume')
    end

    it 'handles no tailored resume found' do
      allow(Resume).to receive(:last).and_return(nil)
      get :download
      expect(response).to redirect_to(uploaded_path)
      expect(flash[:alert]).to eq('No tailored resume is available for download.')
    end
  end

  describe 'GET #editor' do
    it 'renders the editor template' do
      last_resume = instance_double('Resume', title: 'Sample Last Resume')
      allow(Resume).to receive(:last).and_return(last_resume)

      get :editor
      expect(response).to render_template('editor')
      expect(assigns(:last_resume)).to eq(last_resume)
    end
  end


 describe 'POST #save' do
  context 'when valid parameters are provided' do
    it 'creates a new resume with a PDF file' do
      file_path = Rails.root.join('spec', 'sample_resume.pdf')
      file = fixture_file_upload(file_path, 'application/pdf')

      allow(PDF::Reader).to receive(:new).and_return(double('reader', pages: [double('page', text: 'Page 1 content')]))

      post :save, params: { resume: { attachment: file } }

      expect(Resume.last.title).to eq(nil)
      expect(assigns(:resume).resume_text).to eq('Page 1 content') # Add this line

      expect(response).to redirect_to(uploaded_path)
      expect(flash[:notice]).to eq('Success! Resume Uploaded')
      expect(flash[:error]).to be_nil
    end

    it 'creates a new resume with unsupported file format' do
      file_path = Rails.root.join('spec', 'sample_resume.txt')
      file = fixture_file_upload(file_path, 'text/plain')

      allow(controller).to receive(:params).and_return({ resume: { attachment: file } }) # Manually set params[:resume][:attachment]

      post :save

      expect(Resume.last.title).to eq('Unsupported file format: text/plain')
      expect(assigns(:resume).resume_text).to eq('Unsupported file format: text/plain') # Add this line

      expect(response).to_not redirect_to(uploaded_path)
      expect(flash[:notice]).to eq('Success! Resume Uploaded')
      expect(flash[:error]).to be_nil
    end
  end

  context 'when invalid parameters are provided' do
    it 'does not create a new resume' do
      post :save, params: { resume: { attachment: nil } }

      expect(Resume.count).to eq(0)
      expect(response).to render_template('new')
      expect(flash[:alert]).to eq('Failed to upload resume. Please try again.')
      expect(flash[:notice]).to eq('Failed to upload resume. Please try again.')
      expect(flash[:error]).to eq('Failed to upload resume. Please try again.')
      #expect(flash[:notice]).to be_nil
      expect(response).to redirect_to(resume_path)
    end
  end
end



  describe 'GET #cancel' do
    it 'sets flash notice and redirects to uploaded_path' do
      get :cancel
      expect(flash[:notice]).to eq('Your resume was not changed')
      expect(response).to redirect_to(uploaded_path)
    end
  end

end