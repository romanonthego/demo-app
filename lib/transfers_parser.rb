require 'csv'
require 'open-uri'

class TransfersParser
  class << self
    def parse_remote url
      csv = open_csv_from_url(url)
      transfers = build_transfers_array(csv)
    end


    def parse_local path
      csv = open_csv_from_file(path)
      transfers = build_transfers_array(csv)
    end


    def open_csv_from_url url
      io = open(url)
      CSV.new io
    end


    def open_csv_from_file path
      CSV.read(path, converters: :all)
    end


    def build_transfers_array csv_course
      transfers = []
      
      csv_course.each do |row|
        transfers << build_tranfer(row)
      end

      transfers
    end


    def build_tranfer row
      Transfer.new({
          sender_id: row[0],
          receiver_id: row[1],
          ammount: row[2],
          payout: row[3],
          transfered_at: row[4]
        })
    end


   def log_parsing_errors url, transfer, i
      message = "Transfer entry errors: #{transfer.errors.messages.map {|k,v| "#{k} - #{v.join("; ")}"}.join("; ")}"
      Rails::logger.error "Invalid record in parsed CSV file - #{url} at line #{i}"
      Rails::logger.error message

      message
    end
  end
end