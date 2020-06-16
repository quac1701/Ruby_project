user = User.new
user.email = "admin@gmail.com"
user.password = "admin@123"
user.password_confirmation = "admin@123"
user.nickname = "Admin"
user.role = "superadmin"
user.skip_confirmation!
user.save

Category.create(name: "Novel")
Category.create(name: "References Book")
