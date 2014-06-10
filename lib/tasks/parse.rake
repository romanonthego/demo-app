namespace :parse do
  desc 'generate remote csv file with data'
  task :remote, [:url] => :environment do |t, args|
    args.with_defaults({url: "https://s3-eu-west-1.amazonaws.com/vrtest/transfers.csv"})
    transfers = TransfersParser.parse_remote(args[:url])

    check_and_save_transfers(transfers, args[:url])
  end
  
  desc 'parse local csv file'
  task :local, [:path] => :environment do |t, args|
    args.with_defaults({path: "#{Rails.root}/db/transfers.csv"})
    transfers = TransfersParser.parse_local args[:path]

    check_and_save_transfers(transfers, args[:path])
  end


  def check_and_save_transfers transfers, source
    added = 0
    skipped = 0
    errors = []

    transfers.each_with_index do |tr, i|
      if tr.valid?
        tr.save
        added += 1
      else
        message = TransfersParser.log_parsing_errors source, tr, i
        errors << " line #{i}, #{message}"
        skipped += 1
      end
    end

    puts "Entries added: #{added}"
    puts "Entries skipped: #{skipped}"
    
    if skipped > 0
      puts errors.join("\n")
    end
  end


end