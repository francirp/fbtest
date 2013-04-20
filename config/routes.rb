Fbtest::Application.routes.draw do
  get 'photos/:friend_id', :controller => 'Photos', :action => 'display_photos'
end
