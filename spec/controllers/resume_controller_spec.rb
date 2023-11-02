require 'rails_helper'

RSpec.describe ResumeController, type: :controller do
  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe 'POST #create' do
    it 'creates a new resume with file' do
      file = fixture_file_upload('path/to/your_resume.pdf', 'application/pdf')
      post :create, params: { resume: { file: file } }
      expect(response).to redirect_to(uploaded_path)
    end

    it 'creates a new resume with resume text' do
      post :create, params: { resume: { resume_text: 'Your resume text' } }
      expect(response).to redirect_to(uploaded_path)
    end

    it 'renders the new template on failure' do
      post :create, params: { resume: { resume_text: '' } }
      expect(response).to render_template('new')
    end
  end

  describe 'POST #tailor' do
    it 'tailors the resume' do
      post :tailor, params: { description: 'Job description' }
      expect(response).to redirect_to(uploaded_path)
    end
  end

  describe 'GET #download' do
    it 'downloads the tailored resume' do
      get :download
      expect(response.body).to include('Tailored Resume Content')
    end

    it 'handles no tailored resume found' do
      allow(Resume).to receive(:last).and_return(nil)
      get :download
      expect(response).to redirect_to(uploaded_path)
    end
  end

  describe 'GET #editor' do
    it 'renders the editor template' do
      get :editor
      expect(response).to render_template('editor')
    end
  end
end
