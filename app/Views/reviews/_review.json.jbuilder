json.extract! review, :id, :content, :book_id, :user_id, :created_at, :updated_at
json.url review_url(review, format: :json)
