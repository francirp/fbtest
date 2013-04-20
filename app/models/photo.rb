require 'open-uri'

class Photo

  attr_accessor :photo_url, :comments, :caption, :owner, :object_id, :created

  class Comment < Photo
    attr_accessor :text
    attr_accessor :from_id
  end

  class Person
    attr_accessor :user_id
    attr_accessor :full_name
  end


  def Photo.query_photos(friend_id, access_token)

  recipient_id = friend_id
  query1request = "SELECT src_big, caption, object_id, owner, aid, created FROM photo WHERE object_id IN(SELECT object_id FROM photo_tag WHERE subject = me()) AND object_id IN(SELECT object_id FROM photo_tag WHERE subject=#{recipient_id})"
  query2request = 'SELECT text, fromid, object_id FROM comment WHERE object_id IN(SELECT object_id FROM #query1)'
  query3request = 'SELECT name, uid FROM user WHERE uid IN(SELECT owner FROM #query1)'

  options = { :access_token => "#{access_token}" }
    photos_api = Fql.execute({
    :query1 => query1request,
    :query2 => query2request,
    :query3 => query3request,
    }, options)

  photos_clean_api = photos_api[0]["fql_result_set"]
  comments_clean_api = photos_api[1]["fql_result_set"]
  owner_clean_api = photos_api[2]["fql_result_set"]

    @photos = []
    @comments = []
    @owners = []

    photos_clean_api.each do |photo|
      s = Photo.new
      s.photo_url = photo["src_big"]
      s.caption = photo["caption"]
      s.object_id = photo["object_id"]
      s.owner = photo["owner"]
      s.created = Date.strptime(photo["created"].to_s,'%s')
      @photos << s
    end

    comments_clean_api.each do |comment|
      s = Comment.new
      s.object_id = comment["object_id"]
      s.text = comment["text"]
      s.from_id = comment["fromid"]
      @comments << s
    end

    owner_clean_api.each do |owner|
      s = Person.new
      s.user_id = owner["uid"]
      s.full_name = owner["name"]
      @owners << s
    end


    @comments_object_ids = []
    comments_clean_api.each do |comment|
      @comments_object_ids << comment["object_id"]
    end

    @owners_user_ids = []
    owner_clean_api.each do |owner|
      @owners_user_ids << owner["uid"]
    end
    @all = [@photos, @comments, @owners, @comments_object_ids, @owners_user_ids]
  end
end
