Fabricator(:review) do
  content { Faker::Lorem.paragraph(3) }
  rating { Random.rand(1..5) }
  user
  video
end