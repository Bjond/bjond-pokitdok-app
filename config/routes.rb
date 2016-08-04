Rails.application.routes.draw do

  root 'bjond_registrations#index'

  post '/x12/incoming' => 'x12#incoming'

  get '/callsamplepokitdok' => 'home#call_pokitdok'

  post 'bjond-app/services/consequence/update' => 'consequence#update'

  post 'bjond-app/services/consequence/checkpokitdok' => 'consequence#checkpokitdok'

  resources :pokit_dok_configurations

end
