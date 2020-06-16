json.extract! book, :id, :title, :author, :public_year, :user_id, :created_at, :updated_at
json.url book_url(book, format: :json)
