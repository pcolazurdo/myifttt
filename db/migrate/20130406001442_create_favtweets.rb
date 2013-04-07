class CreateFavtweets < ActiveRecord::Migration
  def change
    create_table :favtweets do |t|
      t.text :screen_name
      t.text :full_text
      t.text :contenthash
      t.date :timestamp

      t.timestamps
    end
  end
end
