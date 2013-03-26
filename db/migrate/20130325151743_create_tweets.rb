class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :text
      t.datetime :tweeted_at
      t.references :tweeter
      t.timestamps
    end
  end
end
