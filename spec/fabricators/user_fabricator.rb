Fabricator(:user) do 
  email { Faker::Internet.email }
  password { "1234" }
  full_name { Faker::Name.name }
end