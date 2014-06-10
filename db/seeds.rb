agents = []
10.times do 
  agents << {name: Faker::Company.name}
end

Agent.create(agents)