class AddColumnsToFavtweets < ActiveRecord::Migration
  def change
    add_column :favtweets, :tweetorigin, :string
  end
end
