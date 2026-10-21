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
  # Q: What URL path lists the children of one parent?
  # A: /attendees/:attendee_id/tickets  (for example /attendees/1/tickets)
  # Q: Which route parameter holds the parent's id?
  # A: :attendee_id. In /attendees/1/tickets/7, :attendee_id is 1 and :id is the ticket's own id, 7.
  #    Under the festival nesting the parent's id is :festival_id.
  # Q (Pair C): Tickets are nested in two places. Why might both be justified?
  # A: A ticket has two parents and each answers a different question.
  #    One attendee's purchase history -> /attendees/:attendee_id/tickets
  #    One festival's ticket sales     -> /festivals/:festival_id/tickets
  #    Buying a ticket is something an attendee does, so the attendee nesting gets
  #    the full set of actions. The festival side is a read-only sales report, so
  #    it only gets index. The festival routes themselves belong to Pair A
  #    (`only: []` nests under festivals without re-defining them).
  resources :attendees do
    resources :tickets
  end

  resources :festivals, only: [] do
    resources :tickets, only: [:index]
  end



  # ---------- Integrator: Stage / Artist -> Performance ----------



end
