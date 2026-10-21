class CreateFestivals < ActiveRecord::Migration[7.1]
    def change
        create_table :festivals do |t|
            t.string :name
            t.date :starts_on
            t.string :city
            t.timestamps
        end
    end
end