Rails.application.routes.draw do
  root to: "audio_files#new"
  resources :audio_files
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
