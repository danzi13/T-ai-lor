Rottenpotatoes::Application.routes.draw do
  #resources :movies
  # map '/' to be a redirect to '/movies'
  resources :resume, only: [:new, :create]
  root :to => redirect('/resume')

  get '/resume', to: 'resume#new', as: 'resume'

  get '/uploaded', to: 'resume#uploaded', as: 'uploaded'

  post '/tailor', to: 'resume#tailor', as: 'tailor'

  get '/download', to: 'resume#download', as: 'download'

  get '/editor', to: 'resume#editor', as: 'editor'
end
