Rails.application.routes.draw do
  # Phases 3 and 4: add your nested routes in YOUR section only.
  # Staying inside your own section keeps merge conflicts small.
  # Check your work with:  bin/rails routes | grep <resource>


  # ---------- Pair A: Festival -> Stage ----------
  # URL to list stages for one festival: /festivals/:festival_id/stages
  # parent id parameter: :festival_id
  resources :festivals do
    resources :stages
  end


  # ---------- Pair B: Artist -> Track (use shallow nesting) ----------
  # artist_track_index GET    /artists/:artist_id/track(.:format) track#index
  #                  POST   /artists/:artist_id/track(.:format) track#create
  #          artists GET    /artists(.:format)                  artists#index
  #                  POST   /artists(.:format)                  artists#create
  #           artist GET    /artists/:id(.:format)              artists#show
  #                  PATCH  /artists/:id(.:format)              artists#update
  #                  PUT    /artists/:id(.:format)              artists#update
  #                  DELETE /artists/:id(.:format)              artists#destroy

  # :artist_id holds the id of the artist
  # put patch and delete for artist_track dissapeared when we added shallow:true


  resources :artists do
    resources :track, shallow:true
    resources :performances
  end


  # ---------- Pair C: Attendee -> Ticket (and Festival -> Ticket) ----------



  # ---------- Integrator: Stage / Artist -> Performance ----------



end
