Fbtest::Application.routes.draw do
  get '/home', :controller => 'Photos', :action => 'start_photos'
  get '/photos/:friend_id', :controller => 'Photos', :action => 'display_photos'
end
