### Ruby version

ruby 2.0 and up (ruby 1.9.x should do too, but was not tested )

### System dependencies

```shell
bundle install
```

### Database creation

```shell
rake db:create
rake db:migrate
```

### Database initialization

```shell
rake generate:data
```

### How to run the test suite

```shell
rspec
```


# THE QUEST
This demo app is here as a solution for a folowing test:

```text
there is CSV on S3 (sender_id, receiver_id, payout, timestamp)
there is a table agents (id, name)
there is a table transfers(id, sender_id, receiver_id, amount, payout, transfered_at)
there is a table transfers_1h(id, sender_id, receiver_id, amount, payout, starts_at)
transfers_1h is aggregation for table transfers on one hour base.

so entries from transfers like:
1,2,1000,100, 2014-10-01 12:32:43
1,2,1000,100, 2014-10-01 12:12:43
1,2,1000,100, 2014-10-01 12:22:43

is aggregated in transfers_1h into:
1,2,3000,300, 2014-10-01 12:00:00
```

### Why rails not **just** ruby?
Ruby **or** Rails stack was not specified so i choose more convenient way to do it:

* I will use ActiveSupport anyway just becouse it is... well, convenient
* I will use ActiveRecoed anyway becouse I'll need to establish connection with database, validate models and stuff
* I will use some kind of console interface anyway, so why no rake?
* I will use rspec as test suite base
You've got an idea...

# THE SOLUTION

## User rake to pass the url/path and parse the given CSV file:

```shell
rake parse:local["path/to/file"]
rake parse:local # #{Rails.root}/db/transfers.csv will be used
# => Entries added: 9
# => Entries skipped: 1
# =>   line 3, Transfer entry errors: ammount - must be greater than or equal to 0; payout - must be greater than or equal to 0

# same for remote
rake parse:remote["https://s3-eu-west-1.amazonaws.com/vrtest/transfers.csv"]
# => Entries added: 100
# => Entries skipped: 0
```

## Use custom parser class under the rake task:

```ruby
# lib/transfers_parser.rb
require 'csv'
require 'open-uri'

class TransfersParser
  class << self

  ...
  
  end
end
```
Open the CSV and build an array of Transfer entries, no rocket sciense

## Use callback for Transfer on after_create hook to generate or update aggregated entry

```ruby
# app/models/transfer.rb
class Transfer < ActiveRecord::Base
  after_create :aggregate

  private
  def aggregate
    ::Transfer1h.aggregate(self)
  end
end
```

which is basicly send saved entry to the Transfer1h class

## Find relevant aggregated transfer entry and add an ammout and payout to overall values. If not found - generate new one with the values of single transfer as the first one

```ruby
class Transfer1h < ActiveRecord::Base
  # draw transfer in
  # if no aggreagted transfer is present new one will be created
  def self.aggregate transfer
    # try find an existing Transfer1H 
    aggregation = self.find_by_transfer transfer

    # build new one if not present
    if aggregation.blank?
      aggregation = self.new
    end

    # suck in a transfer
    aggregation.aggregate transfer

    # aaaand just save it )
    aggregation.save
  end
end

```

### That's it folks :)

# QA

## But why callback? Aren't we discussed it already?

Well, there is an other matter. I pefer to keep this things as low-level as possible - if i could, i would write a database trigger, but it would be cheating )
Point is - I want to be 100% sure what any Transfer that get into database is reflected in Transfer1h and I willing to sacrifice some performance for that.

## But there is a 2N SQL requests!

Yes there is. And i'm ok with it.
If it is ever become an performance issue - I will consider moving it into stack-like delayed job, that updated transfers_1h table every N minutes with all acquired data. But for now - just like this. After all - it is demo app, I'm not paid for this :)

## Your Parser need some work and testing!

It most certainly does. I will fix it later.

