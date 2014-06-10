require 'csv'

namespace :generate do

  desc 'generate csv file with the data'
  task :data, [:count] => :environment do |task, args|
    args.with_defaults({count: 100})
    # generate agents if not present
    Rake::Task["generate:agents"].invoke unless Agent.any?

    # path to csv
    path = "#{Rails.root}/db/transfers.csv"

    # write to csv
    agents = Agent.all

    # aand write it
    CSV.open(path, "wb") do |csv|
      args[:count].to_i.times do |t|
        entry = build_entry(agents)
        csv << entry
      end
    end
  end


  desc 'generate agents'
  task :agents => :environment do
    agents = []
    
    10.times do 
      agents << {name: Faker::Company.name}
    end

    Agent.create(agents)
  end

  def build_entry agents
    relevant_angents = agents.sample(2)
    amount = 1000 + rand(5..10)*100 - rand(0..20)*100
    time = Time.now - rand(1..3).hours - rand(1..2).days

    entry = [
        relevant_angents[0].id,
        relevant_angents[1].id,
        amount,
        amount/10,
        time
      ]
  end
end