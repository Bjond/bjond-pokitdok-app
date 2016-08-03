Rails.application.routes.draw do

  root 'bjond_registrations#index'

  post '/x12/incoming' => 'x12#incoming'

  get '/callsamplepokitdok' => 'home#call_pokitdok'

  post '/consequence/update' => 'consequence#update'

  post '/consequence/checkpokitdok' => 'consequence#checkpokitdok'

end
