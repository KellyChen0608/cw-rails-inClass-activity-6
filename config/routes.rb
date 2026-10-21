Rails.application.routes.draw do
  # Phases 3 and 4: add your nested routes in YOUR section only.
  # Staying inside your own section keeps merge conflicts small.
  # Check your work with:  bin/rails routes | grep <resource>


  # ---------- Pair A: Festival -> Stage ----------



  # ---------- Pair B: Artist -> Track (use shallow nesting) ----------
  # artist_track_index GET    /artists/:artist_id/track(.:format) track#index
  #                  POST   /artists/:artist_id/track(.:format) track#create
  #          artists GET    /artists(.:format)                  artists#index
  #                  POST   /artists(.:format)                  artists#create
  #           artist GET    /artists/:id(.:format)              artists#show
  #                  PATCH  /artists/:id(.:format)              artists#update
  #                  PUT    /artists/:id(.:format)              artists#update
  #                  DELETE /artists/:id(.:format)              artists#destroy

  resources :artists do
    resources :track, shallow:true
  end


  # ---------- Pair C: Attendee -> Ticket (and Festival -> Ticket) ----------



  # ---------- Integrator: Stage / Artist -> Performance ----------



end
