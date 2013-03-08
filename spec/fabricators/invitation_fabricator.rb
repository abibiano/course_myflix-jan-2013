Fabricator(:invitation) do
  user
  message { Faker::Lorem.paragraph(3) }
  friend_full_name { Faker::Name.name }
  friend_email { Faker::Internet.email }
end