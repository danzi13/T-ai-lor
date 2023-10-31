Rottenpotatoes::Application.routes.draw do
  #resources :movies
  # map '/' to be a redirect to '/movies'
  #root :to => redirect('/resume')

  get '/resume', to: 'resume#show', as: 'resume'

  get '/uploaded', to: 'resume#uploaded', as: 'uploaded'
end
