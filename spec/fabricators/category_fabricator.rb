Fabricator(:category) do 
  name { sequence(:category) { |i| "Category #{i}" } }
end