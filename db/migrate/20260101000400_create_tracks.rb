class CreateTracks < ActiveRecord::Migration[7.1]
  def change
    create_table :tracks do |t|
      t.string  :title
      t.integer :length_sec
      t.references :artist, foreign_key: true
      t.timestamps
    end
  end
end


