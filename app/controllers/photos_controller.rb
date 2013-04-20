require 'open-uri'

class PhotosController < ApplicationController


    def start_photos
    end

    def display_photos
    friendid = params["friend_id"]
    access_token = params["access_token"]

    @all_photos = Photo.query_photos(friendid, access_token)
    @photos = @all_photos[0]
    @comments = @all_photos[1]
    @owners = @all_photos[2]
    @comments_object_ids = @all_photos[3]
    @owners_user_ids = @all_photos[4]
    end
end
