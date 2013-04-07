class Favtweet < ActiveRecord::Base
  attr_accessible :contenthash, :full_text, :screen_name, :timestamp
end
