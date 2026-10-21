class CreateStages < ActiveRecord::Migration[7.1.6]
    def change
        create_table :stages do |t|
            t.string :name, null: false
            t.integer :capacity
            t.references :festival, foreign_key: true, null: false
            t.timestamps
        end
    end
end