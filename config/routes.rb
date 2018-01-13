Rails.application.routes.draw do
  
  resources :attendancesheets
  devise_for :users
  
  post 'main/import'
  
  get 'main/getSheet'
  get 'download/view'
  
  authenticated :user do
    devise_scope :user do
      root "main#dashboard"
    end
  end
  
  devise_scope :user do
    root to: "devise/sessions#new"
  end
  
end
