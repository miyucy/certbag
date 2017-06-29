Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :certificate_authorities, only: %i[index new create]
  get '/:ca_name', to: 'certificate_authorities#show', as: 'certificate_authority'
  scope '/:ca_name' do
    resources :server_certificates
    resources :client_certificates
  end
  root to: 'certificate_authorities#index'
end
