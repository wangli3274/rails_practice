json.array!(@posters) do |poster|
  json.extract! poster, :id, :title, :content, :create_at, :update_at, :user_id
  json.url poster_url(poster, format: :json)
end
