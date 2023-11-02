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


  
  describe 'POST #save' do
    context 'when valid parameters are provided' do
      it 'creates a new resume with the provided title' do
        post :save, params: { resume: 'Your new resume title here' }
        expect(Resume.last.title).to eq('Your new resume title here')
      end

      it 'redirects to the uploaded_path' do
        post :save, params: { resume: 'Your new resume title here' }
        expect(response).to redirect_to(uploaded_path)
      end

      it 'sets a success notice' do
        post :save, params: { resume: 'Your new resume title here' }
        expect(flash[:notice]).to eq('Success! Resume Updated')
      end
    end

    context 'when invalid parameters are provided' do
      it 'does not create a new resume' do
        post :save, params: { resume: '' } 
        expect(Resume.count).to eq(0)
      end

      it 'does not set a success notice' do
        post :save, params: { resume: '' }
        expect(flash[:notice]).to be_nil
      end
    end
  end


  it 'sets flash messages when description is empty' do
    post :tailor, params: { description: '' }
    expect(flash[:alert]).to eq('Warning: you have not tailored your resume for editing or downloading')
    expect(flash[:notice]).to eq('No description, try again')
    expect(response).to redirect_to(uploaded_path)
  end

end
